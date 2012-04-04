//=require urm
//=require spec_helper

describe("tst", function(){
 it("should ok", function(){ true.should.equal(true); });
});

describe("test template", function(){
 //before(function(){
 //});
 it("should show test", function(){
  $("#konacha").html(JST['templates/test']());
  $("#konacha").text().should.contain("test");
 });
});
/*describe("insertGap", function(){
 var foursquare, request;
 var onSuccess, onFailure;
 //beforeEach(function(){
 // setFixtures("<table><tr class='item_tst'><td></td></tr><tr class='dms_item_tst'><td></td></tr></table>");
 // insertGap('tst', "<tr class='gap_tst'><td></td></tr>");
 //});
 it("should insert gap into table", function(){
  expect($('tr').length).toBeGreaterThan(2);
 });
 it("should make gap visible", function(){
  expect($('tr.gap_tst')).toBeVisible();
 });
 it("should insert gap after dms", function(){
  expect($("tr").last()).toBe(".gap_tst");
 });
});

var DmsResponses = {
 dms: {
  success: {
   status: 200,
   responseText: '{"dms":"<tr class=\'dms_item_tst\'><td></td></tr>","gap":"<tr class=\'gap_tst\'><td></td></tr>"}'
  }
 }
};

describe("showDms", function(){
 describe("when no dms exist", function(){
  beforeEach(function(){
   onSuccess = jasmine.createSpy('onSuccess');
   onFailure = jasmine.createSpy('onFailure');
   setFixtures("<table><tr class='item_tst'><td><div class=\"icons\"><div class=\"icon\"><div class=\"dms js\"> </div></div></div></td></tr><tr class='info_item_tst'><td></td></tr></table>");
   jasmine.Ajax.useMock();
   search_icons_handle();
   $(".icon .dms.js").click();
   request = mostRecentAjaxRequest();
  });
  it("should add dms line", function(){
   expect($(".dms_item_tst")).not.toExist();
   request.response(DmsResponses.dms.success);
   expect($(".dms_item_tst")).toExist();
  });

 });
 describe("when dms only exists and visible", function(){
  beforeEach(function(){
   onSuccess = jasmine.createSpy('onSuccess');
   onFailure = jasmine.createSpy('onFailure');
   setFixtures("<table><tr class='item_tst'><td><div class='icons'><div class='icon'><div class='dms js'> </div></div></div></td></tr><tr class='info_item_tst'><td></td></tr><tr class='dms_item_tst'><td> </td></tr><tr class='gap_tst'><td><td></tr></table>");
   jasmine.Ajax.useMock();
   search_icons_handle();
   $(".icon .dms.js").click();
   request = mostRecentAjaxRequest();
  });
  it("should hide dms");
  it("should hide gap");
 });
});

describe("search_icons_handle", function(){
 beforeEach(function(){
  loadFixtures("fixtures/urm_search_icons_handle.html");
 });

 it("should init dms icons for only first locations", function(){
  expect($(".dms")).not.toBeEmpty();
 });
});
*/

