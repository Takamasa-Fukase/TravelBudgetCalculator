//
//  CurrencyType.swift
//  TravelBudgetCalculator
//
//  Created by ウルトラ深瀬 on 30/8/24.
//

import Foundation

enum CurrencyType: String, CaseIterable {
    case USD = "USD アメリカ ドル"
    case GBP = "GBP イギリス ポンド"
    case CAD = "CAD カナダ ドル"
    case CHF = "CHF スイス フラン"
    case SEK = "SEK スウェーデン クローネ"
    case DKK = "DKK デンマーク クローネ"
    case NOK = "NOK ノルウェー クローネ"
    case JPY = "JPY 円"
    case AUD = "AUD オーストラリア ドル"
    case CNY = "CNY 人民元"
    case NZD = "NZD ニュージーランド ドル"
    case HKD = "HKD 香港ドル"
    case SGD = "SGD シンガポール ドル"
    case BDT = "BDT バングラデシュ タカ"
    case MYK = "MYK ミャンマー チャット"
    case CAR = "CAR カンボジア リエル"
    case INR = "INR インド ルピー"
    case IDR = "IDR インドネシア ルピー"
    case LAK = "LAK ラオス キャプ"
    case MYR = "MYR マレーシア リンギッド"
    case NPR = "NPR ネパール ルピー"
    case PKR = "PKR パキスタン ルビー"
    case PGK = "PGK パプアニューギニア キナ"
    case PHP = "PHP フィリピン ペソ"
    case KRW = "KRW 韓国 ウォン"
    case LKR = "LKR スリランカ ルビー"
    case TWD = "TWD 台湾 ドル"
    case THB = "THB タイ バーツ"
    case VND = "VND ベトナム ドン"
    case SUR = "SUR ロシア ルーブル"
    case BHD = "BHD バハレーン ディナール"
    case IRR = "IRR イラン リヤル"
    case IQD = "IQD イラク ディナール"
    case KWD = "KWD クウェート ディナール"
    case OMR = "OMR オマーン リヤル"
    case QAR = "QAR カタール リヤル"
    case SAR = "SAR サウジアラビア リヤル"
    case AED = "AED UAE ディルハム"
    case PYG = "PYG パラグアイ グアラーニ"
    case CRC = "CRC コスタリカ コロン"
    case CUP = "CUP キューバ ペソ"
    case GTQ = "GTQ グアテマラ ケツラル"
    case HNL = "HNL ホンジュラス レムピーラ"
    case JMD = "JMD ジャマイカ ドル"
    case ARA = "ARA アルゼンチン ペソ"
    case BOB = "BOB ボリビア ボリビアーノ"
    case BRL = "BRL ブラジル レアル"
    case CLP = "CLP チリ ペソ"
    case COP = "COP コロンビア ペソ"
    case PEI = "PEI ペルー インティ"
    case UYP = "UYP ウルグアイ ペソ"
    case VEB = "VEB ベネズエラ ボリバール"
    case DZD = "DZD アルジェリア ディナール"
    case BGP = "BGP エジプト ポンド"
    case XAF = "XAF CFA フラン"
    case GHC = "GHC ガーナ セディ"
    case KES = "KES ケニア シリング"
    case MAD = "MAD モロッコ ダーラム"
    case NGN = "NGN ナイジェリア ナイラ"
    case ZAR = "ZAR 南アフリカ ランド"
    case TND = "TND チュニジア ディナール"
    case ZWD = "ZWD ジンバブエ ドル"
    case MXN = "MXN メキシコ ペソ"
    case EUR = "EUR ユーロ"
    case CZK = "CZK チェコ コルナ"
    case HUF = "HUF ハンガリー フォリント"
    case PLZ = "PLZ ポーランド ズロチ"
    case TRY = "TRY トルコ リラ"
    
    // Return the currency code only (3-letter code)
    var code: String {
        return self.rawValue.components(separatedBy: " ").first ?? self.rawValue
    }

    // Return the description (name with the currency code)
    var description: String {
        return self.rawValue
    }
    
    var toYenRate: Double {
        // TODO: UDに保存されているデータを返す
        switch self {
        case .USD:
            return 144.93
        case .ARA:
            return 0.15
        case .COP:
            return 0.035
        case .MXN:
            return 7.28
        default:
            return 0.0
        }
    }
}
