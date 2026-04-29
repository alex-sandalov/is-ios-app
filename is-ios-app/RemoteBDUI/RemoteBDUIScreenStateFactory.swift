import Foundation

struct RemoteBDUIScreenStateFactory {
    func makeLoadingScreen() -> BDUIScreenDTO {
        BDUIScreenDTO(
            root: BDUINodeDTO.makeRootScroll(
                id: "remote_bdui_loading_root",
                children: [
                    BDUINodeDTO.makeEmpty(
                        id: "remote_bdui_loading_state",
                        title: "Загрузка",
                        subtitle: "Получаем экран с сервера",
                        actionTitle: nil,
                        action: nil
                    )
                ]
            )
        )
    }

    func makeErrorScreen(
        message: String,
        retryTitle: String
    ) -> BDUIScreenDTO {
        BDUIScreenDTO(
            root: BDUINodeDTO.makeRootScroll(
                id: "remote_bdui_error_root",
                children: [
                    BDUINodeDTO.makeEmpty(
                        id: "remote_bdui_error_state",
                        title: "Не удалось загрузить экран",
                        subtitle: message,
                        actionTitle: retryTitle,
                        action: .callback(id: "remote_bdui_retry")
                    )
                ]
            )
        )
    }
}
