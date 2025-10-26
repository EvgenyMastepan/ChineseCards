//
//  DataSeeder.swift
//  Chinese Card
//
//  Created by Evgeny Mastepan on 26.10.2025.
//

import CoreData

class DataSeeder {
    static func seedInitialData() {
        let context = CoreManager().persistentContainer.viewContext
        
        // Проверяем есть ли уже данные
        let request: NSFetchRequest<Word> = Word.fetchRequest()
        if let count = try? context.count(for: request), count > 0 {
            return // Данные уже есть
        }
        
        // Добавляем тестовые слова HSK1
        let words = [
            ("爱", "ài", "любовь", "love", 1),
            ("八", "bā", "восемь", "eight", 1),
            ("爸爸", "bàba", "папа", "father", 1),
            ("杯子", "bēizi", "чашка", "cup", 1),
            ("北京", "Běijīng", "Пекин", "Beijing", 1),
            ("本", "běn", "экземпляр", "measure word", 1),
            ("不", "bù", "не", "not", 1),
            ("不客气", "bú kèqi", "не за что", "you're welcome", 1),
            ("菜", "cài", "овощи", "vegetables", 1),
            ("茶", "chá", "чай", "tea", 1),
            ("吃", "chī", "есть", "eat", 1),
            ("出租车", "chūzūchē", "такси", "taxi", 1),
            ("打电话", "dǎ diànhuà", "звонить", "make a phone call", 1),
            ("大", "dà", "большой", "big", 1),
            ("的", "de", "показатель принадлежности", "possessive particle", 1),
            ("点", "diǎn", "точка", "point", 1),
            ("电脑", "diànnǎo", "компьютер", "computer", 1),
            ("电视", "diànshì", "телевизор", "TV", 1),
            ("电影", "diànyǐng", "кино", "movie", 1),
            ("东西", "dōngxi", "вещь", "thing", 1),
            ("都", "dōu", "все", "all", 1),
            ("读", "dú", "читать", "read", 1),
            ("对不起", "duìbuqǐ", "извините", "sorry", 1),
            ("多", "duō", "много", "many", 1),
            ("多少", "duōshao", "сколько", "how many", 1),
            ("儿子", "érzi", "сын", "son", 1),
            ("二", "èr", "два", "two", 1),
            ("饭店", "fàndiàn", "ресторан", "restaurant", 1),
            ("飞机", "fēijī", "самолет", "airplane", 1),
            ("分钟", "fēnzhōng", "минута", "minute", 1),
            ("高兴", "gāoxìng", "радостный", "happy", 1),
            ("个", "gè", "универсальный счётник", "general measure word", 1),
            ("工作", "gōngzuò", "работа", "work", 1),
            ("狗", "gǒu", "собака", "dog", 1),
            ("汉语", "Hànyǔ", "китайский язык", "Chinese language", 1),
            ("好", "hǎo", "хороший", "good", 1),
            ("号", "hào", "число", "number", 1),
            ("喝", "hē", "пить", "drink", 1),
            ("和", "hé", "и", "and", 1),
            ("很", "hěn", "очень", "very", 1),
            ("后面", "hòumiàn", "сзади", "behind", 1),
            ("回", "huí", "возвращаться", "return", 1),
            ("会", "huì", "уметь", "can", 1),
            ("几", "jǐ", "сколько", "how many", 1),
            ("家", "jiā", "семья", "family", 1),
            ("叫", "jiào", "звать", "call", 1),
            ("今天", "jīntiān", "сегодня", "today", 1),
            ("九", "jiǔ", "девять", "nine", 1),
            ("开", "kāi", "открывать", "open", 1),
            ("看", "kàn", "смотреть", "see", 1),
            ("看见", "kànjiàn", "увидеть", "see", 1),
            ("块", "kuài", "юань", "yuan", 1),
            ("来", "lái", "приходить", "come", 1),
            ("老师", "lǎoshī", "учитель", "teacher", 1),
            ("了", "le", "глагольный суффикс", "verb particle", 1),
            ("冷", "lěng", "холодный", "cold", 1),
            ("里", "lǐ", "внутри", "inside", 1),
            ("六", "liù", "шесть", "six", 1),
            ("妈妈", "māma", "мама", "mother", 1),
            ("吗", "ma", "вопросительная частица", "question particle", 1),
            ("买", "mǎi", "покупать", "buy", 1),
            ("猫", "māo", "кошка", "cat", 1),
            ("没", "méi", "не", "not", 1),
            ("没关系", "méi guānxi", "ничего", "it's ok", 1),
            ("米饭", "mǐfàn", "рис", "rice", 1),
            ("名字", "míngzi", "имя", "name", 1),
            ("明天", "míngtiān", "завтра", "tomorrow", 1),
            ("哪", "nǎ", "какой", "which", 1),
            ("哪儿", "nǎr", "где", "where", 1),
            ("那", "nà", "тот", "that", 1),
            ("呢", "ne", "вопросительная частица", "question particle", 1),
            ("能", "néng", "мочь", "can", 1),
            ("你", "nǐ", "ты", "you", 1),
            ("年", "nián", "год", "year", 1),
            ("女儿", "nǚ'ér", "дочь", "daughter", 1),
            ("朋友", "péngyou", "друг", "friend", 1),
            ("漂亮", "piàoliang", "красивый", "beautiful", 1),
            ("苹果", "píngguǒ", "яблоко", "apple", 1),
            ("七", "qī", "семь", "seven", 1),
            ("前面", "qiánmiàn", "спереди", "front", 1),
            ("钱", "qián", "деньги", "money", 1),
            ("请", "qǐng", "пожалуйста", "please", 1),
            ("去", "qù", "идти", "go", 1),
            ("热", "rè", "горячий", "hot", 1),
            ("人", "rén", "человек", "person", 1),
            ("认识", "rènshi", "знать", "know", 1),
            ("三", "sān", "три", "three", 1),
            ("商店", "shāngdiàn", "магазин", "shop", 1),
            ("上", "shàng", "верх", "up", 1),
            ("上午", "shàngwǔ", "до полудня", "morning", 1),
            ("少", "shǎo", "мало", "few", 1),
            ("谁", "shéi", "кто", "who", 1),
            ("什么", "shénme", "что", "what", 1),
            ("十", "shí", "десять", "ten", 1),
            ("时候", "shíhou", "время", "time", 1),
            ("是", "shì", "быть", "be", 1),
            ("书", "shū", "книга", "book", 1),
            ("水", "shuǐ", "вода", "water", 1),
            ("水果", "shuǐguǒ", "фрукты", "fruit", 1),
            ("睡觉", "shuìjiào", "спать", "sleep", 1),
            ("说", "shuō", "говорить", "speak", 1),
            ("四", "sì", "четыре", "four", 1),
            ("岁", "suì", "лет", "years old", 1),
            ("他", "tā", "он", "he", 1),
            ("她", "tā", "она", "she", 1),
            ("太", "tài", "слишком", "too", 1),
            ("天气", "tiānqì", "погода", "weather", 1),
            ("听", "tīng", "слушать", "listen", 1),
            ("同学", "tóngxué", "одноклассник", "classmate", 1),
            ("喂", "wèi", "алло", "hello", 1),
            ("我", "wǒ", "я", "I", 1),
            ("我们", "wǒmen", "мы", "we", 1),
            ("五", "wǔ", "пять", "five", 1),
            ("喜欢", "xǐhuan", "нравиться", "like", 1),
            ("下", "xià", "низ", "down", 1),
            ("下午", "xiàwǔ", "после полудня", "afternoon", 1),
            ("下雨", "xià yǔ", "дождь", "rain", 1),
            ("先生", "xiānsheng", "господин", "mister", 1),
            ("现在", "xiànzài", "сейчас", "now", 1),
            ("想", "xiǎng", "хотеть", "want", 1),
            ("小", "xiǎo", "маленький", "small", 1),
            ("小姐", "xiǎojie", "мисс", "miss", 1),
            ("些", "xiē", "несколько", "some", 1),
            ("写", "xiě", "писать", "write", 1),
            ("谢谢", "xièxie", "спасибо", "thank you", 1),
            ("星期", "xīngqī", "неделя", "week", 1),
            ("学生", "xuéshēng", "студент", "student", 1),
            ("学习", "xuéxí", "учиться", "study", 1),
            ("学校", "xuéxiào", "школа", "school", 1),
            ("一", "yī", "один", "one", 1),
            ("一点儿", "yìdiǎnr", "немного", "a little", 1),
            ("医生", "yīshēng", "врач", "doctor", 1),
            ("医院", "yīyuàn", "больница", "hospital", 1),
            ("衣服", "yīfu", "одежда", "clothes", 1),
            ("椅子", "yǐzi", "стул", "chair", 1),
            ("有", "yǒu", "иметь", "have", 1),
            ("月", "yuè", "месяц", "month", 1),
            ("在", "zài", "в", "at", 1),
            ("再见", "zàijiàn", "до свидания", "goodbye", 1),
            ("怎么", "zěnme", "как", "how", 1),
            ("怎么样", "zěnmeyàng", "как дела", "how about", 1),
            ("这", "zhè", "этот", "this", 1),
            ("中国", "Zhōngguó", "Китай", "China", 1),
            ("中午", "zhōngwǔ", "полдень", "noon", 1),
            ("住", "zhù", "жить", "live", 1),
            ("桌子", "zhuōzi", "стол", "table", 1),
            ("字", "zì", "иероглиф", "character", 1),
            ("昨天", "zuótiān", "вчера", "yesterday", 1),
            ("坐", "zuò", "сидеть", "sit", 1),
            ("做", "zuò", "делать", "do", 1)
        ]
        
        
        for (character, pinyin, ru, en, level) in words {
            let word = Word(context: context)
            word.character = character
            word.pinyin = pinyin
            word.translationRu = ru
            word.translationEn = en
            word.hskLevel = Int16(level)
            word.id = UUID()
        }
        
        try? context.save()
    }
}
