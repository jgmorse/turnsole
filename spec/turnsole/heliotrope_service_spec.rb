# frozen_string_literal: true
RSpec.describe Turnsole::HeliotropeService do
  heliotrope_service = described_class.new

  n = 3
  products = []
  lessees = []
  components = []

  products_initial_count = heliotrope_service.products.count
  lessees_initial_count = heliotrope_service.lessees.count
  components_initial_count = heliotrope_service.components.count

  before(:all) do
    n.times do |i|
      products << "product#{i}"
      heliotrope_service.find_or_create_product(identifier: products[i])
      lessees << "lessee#{i}@example.com"
      heliotrope_service.find_or_create_lessee(identifier: lessees[i])
      components << "component#{i}"
      heliotrope_service.find_or_create_component(handle: components[i])
    end
  end

  after(:all) do
    n.times do |i|
      n.times do |j|
        heliotrope_service.unlink(product_identifier: products[i], lessee_identifier: lessees[j])
        heliotrope_service.unlink_component(product_identifier: products[i], handle: components[j])
      end
    end
    n.times do |i|
      heliotrope_service.delete_product(identifier: products[i])
      heliotrope_service.delete_lessee(identifier: lessees[i])
      heliotrope_service.delete_component(handle: components[i])
    end
  end

  it 'works' do
    expect(heliotrope_service.products.count).to eq(products_initial_count + n)
    expect(heliotrope_service.lessees.count).to eq(lessees_initial_count + n)
    expect(heliotrope_service.components.count).to eq(components_initial_count + n)

    n.times do |i|
      expect(heliotrope_service.product_lessees(product_identifier: products[i]).count).to eq(0)
      expect(heliotrope_service.lessee_products(lessee_identifier: lessees[i]).count).to eq(0)
      expect(heliotrope_service.product_components(product_identifier: products[i]).count).to eq(0)
      expect(heliotrope_service.component_products(handle: components[i]).count).to eq(0)
    end

    n.times do |i|
      heliotrope_service.link(product_identifier: products[0], lessee_identifier: lessees[i])
    end
    expect(heliotrope_service.product_lessees(product_identifier: products[0]).count).to eq(n)

    n.times do |i|
      heliotrope_service.link(product_identifier: products[i], lessee_identifier: lessees[0])
    end
    expect(heliotrope_service.lessee_products(lessee_identifier: lessees[0]).count).to eq(n)

    n.times do |i|
      heliotrope_service.link_component(product_identifier: products[0], handle: components[i])
    end
    expect(heliotrope_service.product_components(product_identifier: products[0]).count).to eq(n)

    n.times do |i|
      heliotrope_service.link_component(product_identifier: products[i], handle: components[0])
    end
    expect(heliotrope_service.component_products(handle: components[0]).count).to eq(n)

    n.times do |i|
      heliotrope_service.unlink(product_identifier: products[0], lessee_identifier: lessees[i])
      heliotrope_service.unlink(product_identifier: products[i], lessee_identifier: lessees[0])
      heliotrope_service.unlink_component(product_identifier: products[0], handle: components[i])
      heliotrope_service.unlink_component(product_identifier: products[i], handle: components[0])
    end
    expect(heliotrope_service.product_lessees(product_identifier: products[0]).count).to eq(0)
    expect(heliotrope_service.lessee_products(lessee_identifier: lessees[0]).count).to eq(0)
    expect(heliotrope_service.component_products(handle: components[0]).count).to eq(0)
  end
end
