// 
// Javascript that applies globally to all (or at least most) pages of the site.
//
$(document).ready(function () {
   /*
    * Add full with image for background page
    */
    // TODO - come back to this for X-186
	//$("body").backstretch([
    //    "assets/images/modern-elegant-living-room-interior-design.jpg"
    //])
    
    
    /*
     * Custom Bootstrap form logic
     */   
    // Remove error indicators when field clicked on
    $(".form-group.has-error input").click(function () {
        $(this).closest('.form-group').removeClass('has-error');
        $(this).closest('.form-group').find('.help-block').remove();      
    });           
    $(".form-group.has-error select").change(function () {
        $(this).closest('.form-group').removeClass('has-error');
        $(this).closest('.form-group').find('.help-block').remove();
    });

});
