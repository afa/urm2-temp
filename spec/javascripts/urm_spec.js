describe("load_dms", function(){
 beforeEach(function(){
  setFixtures("<tr class='item_tst'><td></td></tr>");
 });
 it("should append ajaxed item", function(){
  load_dms("tst", 1);
  expect($(".dms_item_tst").length).toBeGreaterThan(0);
 });
});

describe("insertGap", function(){
 beforeEach(function(){
  setFixtures("<table><tr class='item_tst'><td></td></tr><tr class='dms_item_tst'></tr></table>");
 });
 it("should insert gap after dms", function(){
  insertGap('tst', "<tr class='gap_tst'><td></td></tr>");
  expect($('tr').length).toBeGreaterThan(2);
  expect($('tr.gap_tst')).toBeVisible();
  expect($("tr").last().hasClass("gap_tst")).toEqual(true);
 });
});
