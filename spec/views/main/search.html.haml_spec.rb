require 'spec_helper'

describe "main/search.html.haml" do
 before do
  #Account.any_instance.stub(:validates_uniqueness_of).and_return(true)
  @login = FactoryGirl.build(:user)
  @login.stub!(:valid?).and_return(true)
  Axapta.stub!(:user_info).with(@login.ext_hash).and_return({})
  #@login.stub!(:unique_hash).and_return(true)
  Axapta.stub!(:user_info).with(@login.ext_hash).and_return({})
  @login.save!
  @items = [{:item_id => 123, :item_name => 'ttt'}]
  assign(:items, @items)
  assign(:accounts, @login.accounts)
  assign(:current_user, @login)
  #controller.send(:current_user=, @login)
  render
 end
 #no anonymous in view. anon - redirected in controller
 it "should show fast search form" do
  rendered.should have_xpath("//form[@action='/search' and @method='post']")
  rendered.should have_xpath("//form//input[@type='text' and @name='search[query_string]']")
 end

 it "should show ext search form" do
  rendered.should have_xpath("//form[@action='/extended' and @method='post']")
  rendered.should have_xpath("//form//input[@name='extended[only_available]' and @type='checkbox']")
  rendered.should have_xpath("//form//input[@name='extended[invent_location_id]' and @type='text']")
  rendered.should have_xpath("//form//input[@name='extended[cust_account]' and @type='text']")
  rendered.should have_xpath("//form//input[@name='extended[query_string]' and @type='text']")
  rendered.should have_xpath("//form//input[@name='extended[search_brend]' and @type='text']")
  rendered.should have_xpath("//form//input[@name='extended[item_id_search]' and @type='text']")
  rendered.should have_xpath("//form//input[@name='extended[calc_qty]' and @type='checkbox']")
  rendered.should have_xpath("//form//input[@name='extended[show_delivery_prognosis]' and @type='checkbox']")
  rendered.should have_xpath("//form//input[@name='extended[calc_price]' and @type='checkbox']")
 end
 it "should render all items" do
  @items.each do |i|
   rendered.should have_xpath("//td", :text => i["item_brend"])
  end
 end
 #it "should show link to "
end

=begin
  items: 
    content: 
      item_brend: 
        getter: getinvcBrendAlias
        title: производитель
        type: string
      item_id: 
        getter: getItemId
        title: код
        type: string
      item_name: 
        getter: getInventItemName
        title: наименование
        type: string
      locations: 
        content: 
          delivery_prognosis: 
            content: 
              delivery_date: 
                getter: getDeliverydate
                type: date
              delivery_qty: 
                getter: getDeliveryQty
                type: date
            iterator: nextPrognosis
            type: array
          location_id: 
            getter: getInventLocationId
            title: склады
            type: string
          price_qty: 
            content: 
              max_qty: 
                getter: getMaxSalesQty
                options: hide_if_empty
                title: "макс. кол-во для цены"
                type: integer
              min_qty: 
                getter: getMinSalesQty
                title: "мин. кол-во для цены"
                type: integer
              price: 
                getter: getPrice
                title: цена
                type: real
              price_ref: 
                getter: getPriceRef
                options: hide_if_empty
                title: "цена продажи"
            iterator: nextPrice
            title: "цены - количества"
            type: array
          vend_qty: 
            getter: getAvailableQty
            title: "всего в наличии"
            type: integer
        iterator: nextLocation
        title: склады
        type: array
      min_qty: 
        getter: getMinQty
        title: "минимальное кол-во"
        type: integer
      package_name: 
        getter: getinvcPackageName
        title: корпус
        type: string
      qty_in_pack: 
        getter: getwmscQtyInPackReq
        title: "кол-во в упаковке"
        type: integer
      rohs: 
        getter: getinvcInventItemPrefix
        title: ROHS
        type: string
      segment_rus: 
        getter: getcmpSegmentEnum
        title: сегмент
        type: segment_rus
    iterator: nextItem
    title: "результаты поиска"
    type: array
=end
