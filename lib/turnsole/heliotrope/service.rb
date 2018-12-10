# frozen_string_literal: true

require 'faraday'
require 'faraday_middleware'
require 'json'

module Turnsole
  module Heliotrope
    class Service # rubocop:disable Metrics/ClassLength
      #
      # Product
      #
      def products
        response = connection.get('products')
        return response.body if response.success?
        []
      end

      def find_product(identifier:)
        response = connection.get("product", identifier: identifier)
        return response.body["id"] if response.success?
        nil
      rescue StandardError => e
        STDERR.puts e.message
        nil
      end

      def create_product(identifier:, name:, purchase: "x")
        response = connection.post("products", { product: { identifier: identifier, name: name, purchase: purchase } }.to_json)
        return response.body["id"] if response.success?
        nil
      rescue StandardError => e
        STDERR.puts e.message
        nil
      end

      def delete_product(identifier:)
        id = find_product(identifier: identifier)
        return if id.nil?
        connection.delete("products/#{id}")
      rescue StandardError => e
        STDERR.puts e.message
        nil
      end

      def product_components(product_identifier:)
        product_id = find_product(identifier: product_identifier)
        return [] if product_id.nil?
        response = connection.get("products/#{product_id}/components")
        return response.body if response.success?
        []
      rescue StandardError => e
        STDERR.puts e.message
        []
      end

      def product_individuals(product_identifier:)
        product_id = find_product(identifier: product_identifier)
        return [] if product_id.nil?
        response = connection.get("products/#{product_id}/individuals")
        return response.body if response.success?
        []
      rescue StandardError => e
        STDERR.puts e.message
        []
      end

      def product_institutions(product_identifier:)
        product_id = find_product(identifier: product_identifier)
        return [] if product_id.nil?
        response = connection.get("products/#{product_id}/institutions")
        return response.body if response.success?
        []
      rescue StandardError => e
        STDERR.puts e.message
        []
      end

      #
      # Component
      #
      def components
        response = connection.get('components')
        return response.body if response.success?
        []
      end

      def find_component(identifier:)
        response = connection.get("component", identifier: identifier)
        return response.body["id"] if response.success?
        nil
      rescue StandardError => e
        STDERR.puts e.message
        nil
      end

      def create_component(identifier:, name:, noid:, handle:)
        response = connection.post("components", { component: { identifier: identifier, name: name, noid: noid, handle: handle } }.to_json)
        return response.body["id"] if response.success?
        nil
      rescue StandardError => e
        STDERR.puts e.message
        nil
      end

      def delete_component(identifier:)
        id = find_component(identifier: identifier)
        return if id.nil?
        connection.delete("components/#{id}")
      rescue StandardError => e
        STDERR.puts e.message
        nil
      end

      def component_products(component_identifier:)
        component_id = find_component(identifier: component_identifier)
        return [] if component_id.nil?
        response = connection.get("components/#{component_id}/products")
        return response.body if response.success?
        []
      rescue StandardError => e
        STDERR.puts e.message
        []
      end

      #
      # Product Component
      #
      def product_component?(product_identifier:, component_identifier:)
        product_id = find_product(identifier: product_identifier)
        component_id = find_component(identifier: component_identifier)
        response = connection.get("/api/products/#{product_id}/components/#{component_id}")
        response.success?
      rescue StandardError => e
        STDERR.puts e.message
        false
      end

      def add_product_component(product_identifier:, component_identifier:)
        product_id = find_product(identifier: product_identifier)
        component_id = find_component(identifier: component_identifier)
        response = connection.put("products/#{product_id}/components/#{component_id}")
        response.success?
      rescue StandardError => e
        STDERR.puts e.message
        false
      end

      def remove_product_component(product_identifier:, component_identifier:)
        product_id = find_product(identifier: product_identifier)
        component_id = find_component(identifier: component_identifier)
        response = connection.delete("products/#{product_id}/components/#{component_id}")
        response.success?
      rescue StandardError => e
        STDERR.puts e.message
        false
      end

      #
      # Individual
      #
      def individuals
        response = connection.get('individuals')
        return response.body if response.success?
        []
      end

      def find_individual(identifier:)
        response = connection.get("individual", identifier: identifier)
        return response.body["id"] if response.success?
        nil
      rescue StandardError => e
        STDERR.puts e.message
        nil
      end

      def create_individual(identifier:, name:, email:)
        response = connection.post("individuals", { individual: { identifier: identifier, name: name, email: email } }.to_json)
        return response.body["id"] if response.success?
        nil
      rescue StandardError => e
        STDERR.puts e.message
        nil
      end

      def delete_individual(identifier:)
        id = find_individual(identifier: identifier)
        return if id.nil?
        connection.delete("individuals/#{id}")
      rescue StandardError => e
        STDERR.puts e.message
        nil
      end

      def individual_products(individual_identifier:)
        id = find_individual(identifier: individual_identifier)
        return if id.nil?
        response = connection.get("individuals/#{id}/products")
        return response.body if response.success?
        []
      rescue StandardError => e
        STDERR.puts e.message
        nil
      end

      #
      # Institution
      #
      def institutions
        response = connection.get('institutions')
        return response.body if response.success?
        []
      end

      def find_institution(identifier:)
        response = connection.get("institution", identifier: identifier)
        return response.body["id"] if response.success?
        nil
      rescue StandardError => e
        STDERR.puts e.message
        nil
      end

      def create_institution(identifier:, name:, entity_id:)
        response = connection.post("institutions", { institution: { identifier: identifier, name: name, entity_id: entity_id } }.to_json)
        return response.body["id"] if response.success?
        nil
      rescue StandardError => e
        STDERR.puts e.message
        nil
      end

      def delete_institution(identifier:)
        id = find_institution(identifier: identifier)
        return if id.nil?
        connection.delete("institutions/#{id}")
      rescue StandardError => e
        STDERR.puts e.message
        nil
      end

      def institution_products(institution_identifier:)
        id = find_institution(identifier: institution_identifier)
        return if id.nil?
        response = connection.get("institutions/#{id}/products")
        return response.body if response.success?
        []
      rescue StandardError => e
        STDERR.puts e.message
        nil
      end

      #
      # Subscriptions
      #

      def product_individual_subscribed?(product_identifier:, individual_identifier:)
        product_id = find_product(identifier: product_identifier)
        individual_id = find_individual(identifier: individual_identifier)
        response = connection.get("products/#{product_id}/individuals/#{individual_id}")
        response.success?
      rescue StandardError => e
        STDERR.puts e.message
        false
      end

      def subscribe_product_individual(product_identifier:, individual_identifier:)
        product_id = find_product(identifier: product_identifier)
        individual_id = find_individual(identifier: individual_identifier)
        response = connection.put("products/#{product_id}/individuals/#{individual_id}")
        response.success?
      rescue StandardError => e
        STDERR.puts e.message
        false
      end

      def unsubscribe_product_individual(product_identifier:, individual_identifier:)
        product_id = find_product(identifier: product_identifier)
        individual_id = find_individual(identifier: individual_identifier)
        response = connection.delete("products/#{product_id}/individuals/#{individual_id}")
        response.success?
      rescue StandardError => e
        STDERR.puts e.message
        false
      end

      def product_institution_subscribed?(product_identifier:, institution_identifier:)
        product_id = find_product(identifier: product_identifier)
        institution_id = find_institution(identifier: institution_identifier)
        response = connection.get("products/#{product_id}/institutions/#{institution_id}")
        response.success?
      rescue StandardError => e
        STDERR.puts e.message
        false
      end

      def subscribe_product_institution(product_identifier:, institution_identifier:)
        product_id = find_product(identifier: product_identifier)
        institution_id = find_institution(identifier: institution_identifier)
        response = connection.put("products/#{product_id}/institutions/#{institution_id}")
        response.success?
      rescue StandardError => e
        STDERR.puts e.message
        false
      end

      def unsubscribe_product_institution(product_identifier:, institution_identifier:)
        product_id = find_product(identifier: product_identifier)
        institution_id = find_institution(identifier: institution_identifier)
        response = connection.delete("products/#{product_id}/institutions/#{institution_id}")
        response.success?
      rescue StandardError => e
        STDERR.puts e.message
        false
      end

      #
      # Configuration
      #
      def initialize(options = {})
        @base = options[:base] || ENV['TURNSOLE_HELIOTROPE_API']
        @token = options[:token] || ENV['TURNSOLE_HELIOTROPE_TOKEN']
      end

      private

        #
        # Connection
        #
        def connection
          @connection ||= Faraday.new(@base) do |conn|
            conn.headers = {
              authorization: "Bearer #{@token}",
              accept: "application/json, application/vnd.heliotrope.v1+json",
              content_type: "application/json"
            }
            conn.request :json
            conn.response :json, content_type: /\bjson$/
            conn.adapter Faraday.default_adapter
          end
        end
    end
  end
end