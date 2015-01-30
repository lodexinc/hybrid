module.exports = angular.module('wordpress-hybrid-client.post').factory '$WPHCPost', ($log, $wpApiPosts, $q, $WPHCConfig, DSCacheFactory) ->
    $log.info '$WPHCPost'

    getCache = () ->
        if DSCacheFactory.get 'post'
            return DSCacheFactory.get 'post'
        DSCacheFactory 'post', $WPHCConfig.post.cache

    get: (id) ->
        deferred = $q.defer()
        itemCache = getCache().get 'item-' + id
        $log.debug itemCache, 'Post cache'
        if itemCache
            deferred.resolve itemCache
        else
            $wpApiPosts.$get id
            .then (response) ->
                getCache().put 'item-' + id, response
                deferred.resolve response
        deferred.promise