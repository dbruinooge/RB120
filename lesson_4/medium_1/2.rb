class InvoiceEntry
  attr_reader :quantity, :product_name

  def initialize(product_name, number_purchased)
    @quantity = number_purchased
    @product_name = product_name
  end

  def update_quantity(updated_count)
    # prevent negative quantities from being set
    quantity = updated_count if updated_count >= 0
  end
end

# `quantity` on line 11 will initialize a new local variable.
# This can be fixed by changing attr_reader to attr_accessor for :quantity, and then
# calling the setter method with `self.quantity.`
# Or, we can use @quantity to update the instance variable directly.
