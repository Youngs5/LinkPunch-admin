//
//  ReportStore.swift
//  LinkPunchAdmin
//
//  Created by 남현정 on 2023/08/25.
//

import Foundation
import FirebaseFirestore

class ReportStore: ObservableObject {
    //Picker
    let assign: [String] = ["최근신고순", "최근게시글순", "신고 많은 순"]
    let nicknameOrTitle: [String] = ["이름", "제목"]
    @Published var pickAssign: String = "최근신고순"
    @Published var pickSearch: String = "이름"
    var promptText: String {
        "\(pickSearch)을 입력하세요"
    }
    
    //검색
    @Published var searchString: String = ""
    @Published var selectedPageNum = 1
    
    //신고된 게시글 샘플데이터
    @Published var reportedArray: [StudyRecruitment] = []
    //숨겨진 게시글 샘플데이터
    @Published var hiddenList: [StudyRecruitment] = []
    //네트워킹 받는 데이터
    @Published var fetchedArray: [StudyRecruitment] = []
    
    // view의 ForEach에 들어가는 데이터
    var pageArray: [StudyRecruitment] {
        let firstIndex = ((selectedPageNum - 1) * 10)
        let lastIndex = (selectedPageNum * 10) - 1
        let range = firstIndex...lastIndex
        var resultArray: [StudyRecruitment] = []
        for index in range {
            if sortedArray.count > index {
                resultArray.append(sortedArray[index])
            } else {
                break
            }
        }
        return resultArray
    }
    
    var searchedData: [StudyRecruitment] {
        searchReportPost(reportedArray, searchString, pickSearch)
    }
    
    var sortedArray: [StudyRecruitment] {
        var sortedArray: [StudyRecruitment] = []
        switch pickAssign {
        case "최근신고순" :
            //0번쨰인덱스가 최근(임시)
            sortedArray = searchedData.sorted(by: { $0.postReport?[0].reportedDate ?? "" > $1.postReport?[0].reportedDate ?? "" })
        case "최근게시글순" :
            sortedArray = searchedData.sorted(by: { $0.createdAt > $1.createdAt})
        case "신고 많은 순" :
            sortedArray = searchedData.sorted(by: { $0.reportCountInfo?.total ?? 0 > $1.reportCountInfo?.total ?? 0 })
        default :
            break
        }
        return sortedArray
    }
    
    var pageCount: Int {
        return (sortedArray.count / 10) + 1
    }
    
    func setData() {
        reportedArray = fetchedArray.filter {
            guard let countInfo = $0.reportCountInfo else {
                fatalError(#function)
            }
            return !countInfo.isHiddened
        }
        hiddenList = fetchedArray.filter {
            guard let countInfo = $0.reportCountInfo else {
                fatalError(#function)
            }
            return countInfo.isHiddened
        }
    }
    
    func reportedListCountingByCase(postSidebar: PostSidebar, reportCase: String) -> Int {
        guard let reportCase = ReportCase(rawValue: reportCase) else {
            print(#function + ": fail to optional bind")
            return 0
        }
        switch postSidebar {
            
        case .all :
            return reportedArray.count
        default :
            switch reportCase {
                
            case .unrelated :
                return reportedArray.filter { $0.reportCountInfo?.unrelatedCount ?? 0 > 0 }.count
            case .spamFlagging :
                return reportedArray.filter { $0.reportCountInfo?.spamFlaggingCount ?? 0 > 0 }.count
            case .obscenity :
                return reportedArray.filter { $0.reportCountInfo?.obscenityCount ?? 0 > 0 }.count
            case .offensiveLanguage :
                return reportedArray.filter { $0.reportCountInfo?.offensiveLanguageCount ?? 0 > 0 }.count
            case .etc:
                return reportedArray.filter { $0.reportCountInfo?.etcCount ?? 0 > 0 }.count
                //            return reportManager.reportedList.filter { $0.reportCase == selectedReport}
                //            case:
                //                return sampleArray.filter { $0.reportCase == postSideBar }.count
                
            }
        }
        
    }
    
    
    func hideRecruitment(checkIDs: Set<String>) {
        
        reportedArray = reportedArray.map { sample in
            var updatedSample = sample
            if checkIDs.contains(sample.id) {
                updatedSample.reportCountInfo?.isHiddened = true
            }
            return updatedSample
        }
        
        let tempReportedArray = reportedArray.filter { !checkIDs.contains($0.id) }
        hiddenList += reportedArray.filter { checkIDs.contains($0.id)}
        reportedArray = tempReportedArray
        //원본건드리는 코드
//        StudyRecruitment.sampleData = hiddenList + reportedArray.filter { !checkIDs.contains($0.id) }
    }
    
    //숨김해제 -> 프로퍼티 모두 0으로
    func unhideRecruitment(checkIDs: Set<String>) {
        
        hiddenList = hiddenList.map { sample in
            var updatedSample = sample
            if checkIDs.contains(sample.id) {
                updatedSample.reportCountInfo?.isHiddened = false
                //모두 0으로
                updatedSample.reportCountInfo?.offensiveLanguageCount = 0
                updatedSample.reportCountInfo?.obscenityCount = 0
                updatedSample.reportCountInfo?.spamFlaggingCount = 0
                updatedSample.reportCountInfo?.unrelatedCount = 0
                updatedSample.reportCountInfo?.etcCount = 0
            }
            return updatedSample
        }
        
        
        hiddenList = hiddenList.filter { !checkIDs.contains($0.id) }
        
        //원본건드리는 코드
//        StudyRecruitment.sampleData = reportedArray + hiddenList.filter { !checkIDs.contains($0.id) }
    }
    
    //디테일뷰 삭제버튼
    func deleteRecruitment(checkIDs: Set<String>) {
        
        //        reportedArray = reportedArray.map { sample in
        //            var updatedSample = sample
        //            if checkIDs.contains(sample.id) {
        //                updatedSample.reportCountInfo?.isHiddened = false
        //            }
        //            return updatedSample
        //        }
        
        //        reportedArray = reportedArray.filter { !checkIDs.contains($0.id) }
        //        hiddenList = hiddenList.filter { !checkIDs.contains($0.id) }
        
        //원본건드리는 코드
//        StudyRecruitment.sampleData = StudyRecruitment.sampleData.filter { !checkIDs.contains($0.id) }
        fetchedArray = fetchedArray.filter{ !checkIDs.contains($0.id)}
        self.setData()
    }
    
    
    func sortedArray(data: [StudyRecruitment], pickAssign: String) -> [StudyRecruitment]{
        var sortedArray: [StudyRecruitment] = []
        switch pickAssign {
        case "최근신고순" :
            //0번쨰인덱스가 최근(임시)
            sortedArray = data.sorted(by: { $0.postReport?[0].reportedDate ?? "" > $1.postReport?[0].reportedDate ?? "" })
        case "최근게시글순" :
            sortedArray = data.sorted(by: { $0.createdAt > $1.createdAt})
        case "신고 많은 순" :
            sortedArray = data.sorted(by: { $0.reportCountInfo?.total ?? 0 > $1.reportCountInfo?.total ?? 0 })
        default :
            break
        }
        
        
        return sortedArray
    }
    
    func fetchReportPost(completion: @escaping (Bool) -> Void) {
        fetchedArray.removeAll()
        
        let dataBase = Firestore.firestore().collection("studies")
        dataBase.getDocuments { snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                print("Error fetching data: (error?.localizedDescription ?? ")
                return
            }
            
            for document in snapshot.documents {
                if let jsonData = try? JSONSerialization.data(withJSONObject: document.data(), options: []),
                   let post = try? JSONDecoder().decode(StudyRecruitment.self, from: jsonData) {
                    print(post)
                    
                    if post.reportCountInfo?.total != 0 {
                        self.fetchedArray.append(post)
                    }
                }
            }
            
            completion(true)
            print("파이어베이스 스터디 데이터 가져오기 성공")
            self.setData()
        }
    }
    
    func searchReportPost(_ studyRecruitmentArray: [StudyRecruitment], _ searchString: String, _ pickSearch: String) -> [StudyRecruitment] {
        guard searchString.isEmpty else {
            return studyRecruitmentArray.filter { studyRecruitment in
                if pickSearch == "이름" {
                    return studyRecruitment.publisher.name?.contains(searchString) ?? false
                } else {
                    return studyRecruitment.title.contains(searchString)
                }
            }
        }
        return studyRecruitmentArray
    }
}
