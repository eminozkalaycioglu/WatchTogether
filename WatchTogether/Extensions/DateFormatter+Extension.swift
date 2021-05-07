//
//  DateFormatter+Extension.swift
//  WatchTogether
//
//  Created by emin on 8.05.2021.
//

import Foundation

extension DateFormatter {
    static var wtDateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "yyyy.MM.dd HH:mm:ss"
        return df
    }
}
