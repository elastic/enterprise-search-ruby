# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

# frozen_string_literal: true

require 'spec_helper'

describe Elastic::EnterpriseSearch::AppSearch::Client do
  let(:host) { 'https://localhost:8080' }
  let(:api_key) { 'api_key' }
  let(:client) { Elastic::EnterpriseSearch::AppSearch::Client.new(host: host) }
  let(:subject) { client.date_to_rfc3339(date) }

  context 'Date (year=2020, month=1, day=2)' do
    let(:date) { Date.new(2020, 1, 2) }
    it 'serializes' do
      expect(subject).to eq('2020-01-02T00:00:00+00:00')
    end
  end

  context 'Date (year=1995, month=12, day=29)' do
    let(:date) { Date.new(1995, 12, 29) }
    it 'serializes' do
      expect(subject).to eq('1995-12-29T00:00:00+00:00')
    end
  end

  context 'Date (year=2020, month=1, day=2, hour=3, minute=4, second=5)' do
    let(:date) { DateTime.new(2020, 1, 2, 3, 4, 5, '+00:00') }
    it 'serializes' do
      expect(subject).to eq('2020-01-02T03:04:05+00:00')
    end
  end

  context 'Date (year=1995, month=12, day=29, hour=23, minute=44, second=55)' do
    let(:date) { DateTime.new(1995, 12, 29, 23, 44, 55, '-05:00') }
    it 'serializes' do
      expect(subject).to eq('1995-12-29T23:44:55-05:00')
    end
  end

  context 'Date (year=1995, month=12, day=29, hour=23, minute=44, second=55) with Asia/Kolkata (UTC+5:30) Timezone' do
    let(:date) { DateTime.new(1995, 12, 29, 23, 44, 55, '+5:30') }
    it 'serializes' do
      expect(subject).to eq('1995-12-29T23:44:55+05:30')
    end
  end

  context 'Date (year=1995, month=12, day=29, hour=23, minute=44, second=55) with HST (UTC-10:00) Timezone' do
    let(:date) { DateTime.new(2020, 1, 2, 3, 4, 5, '-10:00') }
    it 'serializes' do
      expect(subject).to eq('2020-01-02T03:04:05-10:00')
    end
  end
end
