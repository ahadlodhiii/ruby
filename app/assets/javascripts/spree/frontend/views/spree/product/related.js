//= require spree/frontend/viewport

Spree.fetchRelatedProductcs = function (id, htmlContainer) {
    return $.ajax({
        url: Spree.routes.product_related(id)
    }).done(function (data) {
        htmlContainer.html(data)
        htmlContainer.find('.carousel').carouselBootstrap4()
    })
}

Spree.fetchVendorProducts = function (id, htmlContainer) {
    return $.ajax({
        url: Spree.routes.product_vendor(id)
    }).done(function (data) {
        htmlContainer.html(data)
        htmlContainer.find('.carousel').carouselBootstrap4()
    })
}

document.addEventListener('turbolinks:load', function () {
    var productDetailsPage = $('body#product-details')

    if (productDetailsPage.length) {
        //related products
        var productId = $('div[data-related-products]').attr('data-related-products-id')
        var relatedProductsEnabled = $('div[data-related-products]').attr('data-related-products-enabled')
        var relatedProductsFetched = false
        var relatedProductsContainer = $('#related-products')

        if (!relatedProductsFetched && relatedProductsContainer.length && relatedProductsEnabled && relatedProductsEnabled === 'true' && productId !== '') {
            $(window).on('resize scroll', function () {
                if (!relatedProductsFetched && relatedProductsContainer.isInViewport()) {
                    Spree.fetchRelatedProductcs(productId, relatedProductsContainer)
                    relatedProductsFetched = true
                }
            })
        }

        //vendor products
        var vendorProductId = $('div[data-vendor-products]').attr('data-vendor-products-id')
        var vendorProductsEnabled = $('div[data-vendor-products]').attr('data-vendor-products-enabled')
        var vendorProductsFetched = false
        var vendorProductsContainer = $('#vendor-products')
        if (!vendorProductsFetched && vendorProductsContainer.length && vendorProductsEnabled && vendorProductsEnabled === 'true' && vendorProductId !== '') {
            $(window).on('resize scroll', function () {
                if (!vendorProductsFetched && vendorProductsContainer.isInViewport()) {
                    Spree.fetchVendorProducts(vendorProductId, vendorProductsContainer)
                    vendorProductsFetched = true
                }
            })
        }
    }
})
