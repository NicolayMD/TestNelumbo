//
//  Models.swift
//  NelumboTest
//
//  Created by Nicolay Steven Martinez Diaz on 8/08/25.
//

import Foundation

struct SignInRequest: Encodable {
    let username: String
    let password: String
}
struct SignInResponse: Decodable {
    let token: String?
    let accessToken: String?
}

struct ReportDTO: Codable {
    let id: Int
    let name: String?
    let description: String?
    let folio: String?
    let areaId: Int?
    let departmentId: Int?
    let priorityId: Int?
    let type: String?
    let storeId: Int?
    let createdBy: Int?
    let statusId: Int?
    let createTime: String?
    let updateTime: String?
    let deleteTime: String?

    let area: MiniRef?
    let department: MiniRef?
    let priority: MiniRef?
    let store: StoreRef?
    let createdByUser: UserRef?
    let status: StatusRef?
    let attendingByUser: User?
}

struct User: Codable {
       let id: Int
       let firstName: String
       let lastName: String
       let email: String
}

struct MiniRef: Codable {
    let id: Int?
    let name: String?
    let description: String?
}
struct StoreRef: Codable {
    let id: Int?
    let name: String?
    let keyCode: String?
    let address: String?
    let email: String?
    let phone: String?
}
struct UserRef: Codable {
    let id: Int?
    let firstName: String?
    let lastName: String?
    let email: String?
    let username: String?
}
struct StatusRef: Codable {
    let id: Int?
    let description: String?
}

struct ReportSummary: Codable {
    let id: Int
    let folio: String
    let storeName: String
    let statusText: String
    let createdAt: String?
}
extension ReportSummary {
    init(from dto: ReportDTO) {
        self.id = dto.id
        self.folio = dto.folio ?? "—"
        self.storeName = dto.store?.name ?? "—"
        self.statusText = dto.status?.description ?? "—"
        self.createdAt = dto.createTime
    }
}

struct ReportDetail: Decodable {
    let id: Int
    let name: String?
    let description: String?
    let folio: String?
    let areaId: Int?
    let departmentId: Int?
    let priorityId: Int?
    let type: String?
    let actionPlanImplementedId: Int?
    let storeId: Int?
    let evidences: [EvidenceDTO]?
    let createdBy: Int?
    let statusId: Int?
    let rating: String?
    let ratingComment: String?
    let solutionDate: String?
    let solutionTime: String?
    let reportDate: String?
    let reportUrl: String?
    let userAttendingId: Int?

    let configReportFolio: ConfigReportFolioDTO?

    let statusAttentionId: Int?
    let answerId: Int?
    let detailCreation: DetailCreationDTO?
    let reasonReassign: String?
    let reassignUser: String?
    let reassignTime: String?
    let reasonCancel: String?
    let cancelUser: String?
    let cancelTime: String?
    let categoryId: Int?
    let subcategoryId: Int?
    let subcategoryText: String?
    let userQuestionnaireId: Int?
    let assignedQuestionnaireId: Int?
    let questionId: Int?

    let createTime: String?
    let updateTime: String?
    let deleteTime: String?
    let dateStart: String?
    let dateEnd: String?
    let questionnaireId: Int?
    let notified: Bool?
    let timeNotification: String?

    let area: AreaDetailDTO?
    let department: DepartmentDetailDTO?
    let priority: MiniRef?
    let store: StoreDetailDTO?
    let createdByUser: UserRef?
    let status: StatusRef?

    let reportFolioComments: [CommentDTO]?
    let reportFolioAnswers: [AnswerDTO]?
    let reportFolioUserAssign: [UserAssignDTO]?
    let statusAttention: StatusRef?
    let reportFolioCategory: CategoryDTO?
    let reportFolioSubcategory: SubcategoryDTO?
    let categories: [AssignedCategoryDTO]?
    let attendingByUser: UserRef?

    let assignedQuestionnaire: String?
    let questionnaireMain: String?

    let canDoActions: Bool?
    let canReassign: Bool?
    let usersTracking: [UserRef]?
    let canResponse: Bool?
    let existAnyQuote: Bool?
    let canNotification: Bool?
    let userManageDepartment: String?
    let sla: String?
    let ola: String?
    let existSolutionCaseMgDpto: Bool?
}

struct EvidenceDTO: Decodable {
    let url: String?
    let originalname: String?
    let evidenceTypeId: Int?
}

struct ConfigReportFolioDTO: Decodable {
    let id: Int?
    let max: Int?
    let createBy: Int?
    let askForArea: Bool?
    let createTime: String?
    let isRequired: Bool?
    let maxRejects: Int?
    let updateTime: String?
    let isAreaRequired: Bool?
    let ratingQuestion: String?
    let askForDepartment: Bool?
    let reportFolioGeneral: Bool?
    let enableRatingQuestion: Bool?
    let isDepartmentRequired: Bool?
    let isRatingQuestionRequired: Bool?

    let configActionPlanReportFolioEvidenceTypes: [ConfigEvidenceTypeDTO]?

    let configReportFolioApprover: ConfigApproverRejectDTO?
    let configReportFolioReject: ConfigApproverRejectDTO?
}
struct ConfigEvidenceTypeDTO: Decodable {
    let id: Int?
    let type: String?
    let required: Bool?
    let createTime: String?
    let deleteTime: String?
    let updateTime: String?
    let description: String?
    let evidenceType: EvidenceTypeDTO?
    let evidenceTypeId: Int?
    let paramsConfiguration: ParamsConfigurationDTO?
    let configActionPlanReportFolioId: Int?
}
struct EvidenceTypeDTO: Decodable {
    let id: Int?
    let key: String?
    let statusId: Int?
    let deleteTime: String?
    let create_time: String?
    let description: String?
    let update_time: String?
}
struct ParamsConfigurationDTO: Decodable {
    let min: Int?
    let sizes: Int?
    let types: [String]?
    let amounts: Int?
}
struct ConfigApproverRejectDTO: Decodable {
    let required: Bool?
    let evidenceType: EvidenceTypeLiteDTO?
    let evidenceTypeId: Int?
    let paramsConfiguration: ParamsConfigurationDTO?
}
struct EvidenceTypeLiteDTO: Decodable {
    let id: Int?
    let key: String?
    let statusId: Int?
}

struct DetailCreationDTO: Decodable {
    let answers: [AnswerItemDTO]?
    let section: String?
    let question: String?
    let questionnaire: String?
    let typeQuestionId: Int?
}
struct AnswerItemDTO: Decodable {
    let id: Int?
    let score: String?
    let title: String?
    let iconUrl: String?
    let selected: Bool?
}

struct AreaDetailDTO: Decodable {
    let id: Int?
    let name: String?
    let description: String?
    let userManageId: Int?
}
struct DepartmentDetailDTO: Decodable {
    let id: Int?
    let name: String?
    let description: String?
    let userManageId: Int?
    let userManage: UserRef?
    let userManagers: [UserRef]?
}

struct StoreDetailDTO: Decodable {
    let id: Int?
    let name: String?
    let keyCode: String?
    let address: String?
    let email: String?
    let phone: String?
    let storeTimeZone: StoreTimeZoneDTO?
}
struct StoreTimeZoneDTO: Decodable {
    let id: Int?
    let code: String?
    let zone: String?
    let value: Int?
}

struct CommentDTO: Decodable {
    let id: Int
    let reportFolioId: Int
    let comment: String?
    let createdBy: Int
    let wasReadedByStore: Bool
    let createTime: String
    let updateTime: String
    let deleteTime: String?
    let createdByUser: CreatedByUserDTO
}

struct CreatedByUserDTO: Decodable {
    let id: Int
    let firstName: String?
    let lastName: String?
    let email: String
    let username: String
}

struct AnswerDTO: Decodable {
    
}
struct UserAssignDTO: Decodable {
    let id: Int?
    let firstName: String?
    let lastName: String?
    let email: String?
    let username: String?
    let curp: String?
    let roleId: Int?
    let isReassign: Bool?
}
struct CategoryDTO: Decodable {
    let id: Int?
    let description: String?
}
struct SubcategoryDTO: Decodable {
    let id: Int?
    let description: String?
    let requestText: Bool?
}
struct AssignedCategoryDTO: Decodable {
    let id: Int?
    let reportFolioId: Int?
    let categoryId: Int?
    let category: String?
    let subcategoryId: Int?
    let subcategory: String?
    let priorityId: Int?
    let priority: String?
    let requestText: Bool?
    let subcategoryText: String?
    let userAssignId: Int?
    let createTime: String?
    let updateTime: String?
    let deleteTime: String?
}
