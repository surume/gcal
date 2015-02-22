require "gcal/version"
require 'google/api_client'

module Gcal

  class Gcal

    TOKEN_CREDENTIAL_URI = 'https://accounts.google.com/o/oauth2/token'
    AUDIENCE = 'https://accounts.google.com/o/oauth2/token'
    SCOPE = 'https://www.googleapis.com/auth/calendar.readonly'

    attr_reader :client, :calendar_id

    def initialize(calendar_id, p12key_path, p12pass, mail_adress)
      @client = Google::APIClient.new(application_name: '')
      @calendar_id = calendar_id

      key = Google::APIClient::KeyUtils.load_from_pkcs12(p12key_path, p12pass)
      @client.authorization = Signet::OAuth2::Client.new(
        token_credential_uri: TOKEN_CREDENTIAL_URI,
        audience: AUDIENCE,
        scope: SCOPE,
        issuer: mail_adress,
        signing_key: key)
      @client.authorization.fetch_access_token!
    end

    def today_events
      now = Time.now
      tomorrow = now + (60*60*24)
      params = event_get_params(now.iso8601, tomorrow.iso8601)
      send_params(params)
    end

    def next_day_events
      now = Time.now + (60*60*24)
      tomorrow = now + (60*60*24)
      params = event_get_params(now.iso8601, tomorrow.iso8601)
      send_params(params)
    end

    def one_month_events
      now = DateTime.now
      one_month_after = now >> 1
      params = event_get_params(now.iso8601, one_month_after.iso8601)
      send_params(params)
    end

    def all_day_events
      under_time = Time.new(1000, 1, 1, 0)
      top_time = Time.new(3000, 1, 1, 0)
      params = event_get_params(under_time.iso8601, top_time.iso8601)
      send_params(params)
    end

    def send_params(params)
      cal = discovered_cal_api
      result = @client.execute(api_method: cal.events.list,
                               parameters: params)
      events = []
      result.data.items.each do |item|
        events << item
      end
      events
    end

    def discovered_cal_api
      @client.discovered_api('calendar', 'v3')
    end

    def event_get_params(start_time, end_time)
      {
        'calendarId' => @calendar_id,
        'orderBy' => 'startTime',
        'timeMax' => end_time,
        'timeMin' => start_time,
        'singleEvents' => 'True'
      }
    end

  end
end
