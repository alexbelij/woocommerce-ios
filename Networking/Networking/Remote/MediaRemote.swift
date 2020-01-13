import Foundation
import Alamofire

/// Product: Remote Endpoints
///
public class MediaRemote: Remote {
    public func retrieveMediaLibrary(for siteID: Int64,
                                     pageHandle: String? = nil,
                                     appendingTo existingMediaList: [Media] = [],
                                     context: String? = nil,
                                     completion: @escaping ([Media]?, Error?) -> Void) {
        var parameters: [String: Any] = [
            ParameterKey.contextKey: context ?? Default.context,
            ParameterKey.perPage: 100,
            ParameterKey.fields: "ID,date,URL,title,alt",
            ParameterKey.mimeType: "image"
        ]
        if pageHandle?.isEmpty == false {
            parameters[ParameterKey.page] = pageHandle
        }

        let path = "sites/\(siteID)/media"
        let request = DotcomRequest(wordpressApiVersion: .mark1_1,
                                    method: .get,
                                    path: path,
                                    parameters: parameters)
        let mapper = MediaListEnvelopeMapper()

        enqueue(request, mapper: mapper) { [weak self] (mediaListEnvelope, error) in
            guard let fetchedMediaList = mediaListEnvelope?.mediaList, error == nil else {
                completion(nil, error)
                return
            }

            let mediaList = existingMediaList + fetchedMediaList
            if let nextPageHandle = mediaListEnvelope?.meta?.nextPageHandle, nextPageHandle.isEmpty == false {
                self?.retrieveMediaLibrary(for: siteID, pageHandle: nextPageHandle, appendingTo: mediaList, context: context, completion: completion)
                return
            }

            completion(mediaList, nil)
        }
    }

    // MARK: - Products

    /// Retrieves all of the `Products` available.
    ///
    /// - Parameters:
    ///     - siteID: Site for which we'll fetch remote products.
    ///     - context: view or edit. Scope under which the request is made;
    ///                determines fields present in response. Default is view.
    ///     - pageNumber: Number of page that should be retrieved.
    ///     - pageSize: Number of products to be retrieved per page.
    ///     - orderBy: the key to order the remote products. Default to product name.
    ///     - order: ascending or descending order. Default to ascending.
    ///     - completion: Closure to be executed upon completion.
    ///
    public func uploadMedia(for siteID: Int64,
                            context: String? = nil,
                            mediaItems: [MediaUploadable],
                            completion: @escaping ([Media]?, Error?) -> Void) {
        let parameters = [
            ParameterKey.contextKey: context ?? Default.context,
        ]

        let path = "sites/\(siteID)/media/new"
        let request = DotcomRequest(wordpressApiVersion: .mark1_1,
                                    method: .post,
                                    path: path,
                                    parameters: parameters)
        let mapper = MediaListMapper()

        enqueueMultipartFormDataUpload(request, mapper: mapper, multipartFormData: { multipartFormData in
            mediaItems.forEach { mediaItem in
                multipartFormData.append(mediaItem.localURL,
                                         withName: "media[]",
                                         fileName: mediaItem.filename,
                                         mimeType: mediaItem.mimeType)
            }
        }, completion: completion)
    }
}


// MARK: - Constants
//
public extension MediaRemote {
    enum Default {
        public static let context: String = "display"
    }

    private enum Path {
        static let products   = "products"
    }

    private enum ParameterKey {
        static let page: String       = "page_handle"
        static let perPage: String    = "number"
        static let contextKey: String = "context"
        static let fields: String     = "fields"
        static let mimeType: String   = "mime_type"
    }
}
