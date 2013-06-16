Spree::Admin::ProductsController.class_eval do
  before_filter :load_product_set, :only => :bulk_index

  alias_method :location_after_save_original, :location_after_save

  respond_to :json, :only => :clone

  #respond_override :clone => { :json => {:success => lambda { redirect_to bulk_index_admin_products_url+"?q[id_eq]=#{@new.id}" } } }
  
  def bulk_index
    respond_to do |format|
      format.html
      format.json
    end
  end
  
  def bulk_update
    collection_hash = Hash[params[:_json].each_with_index.map { |p,i| [i,p] }]
    product_set = Spree::ProductSet.new()

    if product_set.save(collection_hash)
      redirect_to bulk_index_admin_products_url :format => :json
    else
      render :nothing => true
    end
  end
  
  protected
  def location_after_save
    if URI(request.referer).path == '/admin/products/bulk_index' 
      bulk_index_admin_products_url
    else 
      location_after_save_original
    end
  end
  
  private
  def load_product_set
    @product_set = Spree::ProductSet.new :collection => collection
  end
end