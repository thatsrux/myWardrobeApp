enum Colore: String, Codable, CaseIterable {
    case rosso = "Rosso"
    case bordeaux = "Bordeaux"
    case arancione = "Arancione"
    case gialloUovo = "Giallo Uovo"
    case giallo = "Giallo"
    case crema = "Crema"
    case lime = "Lime"
    case verdeFluo = "Verde Fluo"
    case verdeFoglia = "Verde Foglia"
    case verdeScuro = "Verde Scuro"
    case verdeOliva = "Verde Oliva"
    case avio = "Avio"
    case avioScuro = "Avio Scuro"
    case celeste = "Celeste"
    case celesteScuro = "Celeste Scuro"
    case blu = "Blu"
    case bluNavy = "Blu Navy"
    case bluNotte = "Blu Notte"
    case viola = "Viola"
    case lilla = "Lilla"
    case fuxiaFluo = "Fuxia Fluo"
    case fuxia = "Fuxia"
    case rosa = "Rosa"
    case marrone = "Marrone"
    case marroneCammello = "Marrone Cammello"
    case marroneScuro = "Marrone Scuro"
    case beige = "Beige"
    case grigio = "Grigio"
    case nero = "Nero"
    case bianco = "Bianco"
    case na = "N/A"
}

let coloriVietati: [Colore: [Colore]] = [
    .bianco: [.crema, .beige],
    .nero: [.marrone, .bluNotte, .verdeScuro, .bordeaux],
    .crema: [.bianco, .beige],
    .beige: [.bianco, .crema]
]

let coloriConsentiti: [Colore: [Colore]] = [
    .rosso: [.bluNotte, .bluNavy, .fuxia, .bianco, .nero, .viola],
    .bordeaux: [.beige, .verdeFoglia, .rosa],
    .rosa: [.avio, .viola, .fuxia, .blu, .bordeaux, .marrone],
    .arancione: [.marroneScuro, .crema, .avioScuro, .bluNotte, .gialloUovo],
    .gialloUovo: [.arancione, .bluNavy, .viola, .verdeOliva],
    .giallo: [.viola, .verdeScuro, .grigio],
    .lime: [.verdeFoglia, .bluNotte, .beige, .grigio],
    .verdeFluo: [.beige, .giallo, .bluNotte, .grigio],
    .verdeFoglia: [.giallo, .verdeScuro, .bordeaux, .marroneScuro],
    .verdeScuro: [.verdeFoglia, .beige, .giallo],
    .verdeOliva: [.gialloUovo, .marrone, .marroneScuro, .crema],
    .avio: [.beige, .fuxia, .rosa, .rosso],
    .avioScuro: [.arancione, .bluNotte, .rosa, .viola, .rosso],
    .blu: [.beige, .rosso, .rosa, .fuxia],
    .bluNavy: [.beige, .rosso, .gialloUovo],
    .bluNotte: [.avioScuro, .rosso, .verdeFluo, .lime],
    .viola: [.giallo, .rosa, .gialloUovo, .rosso, .fuxiaFluo],
    .fuxiaFluo: [.viola, .grigio, .rosa],
    .fuxia: [.blu, .rosso, .avio],
    .marrone: [.verdeOliva, .marroneScuro, .rosa],
    .marroneScuro: [.marrone, .verdeOliva, .verdeFoglia],
    //.grigio: [.verdeFluo, .lime, .giallo, .fuxiaFluo],
    .celeste: [.arancione, .blu, .giallo],
    .celesteScuro: [.bluNotte, .verdeScuro],
    .marroneCammello: [.bluNavy, .beige, .marrone]
]
