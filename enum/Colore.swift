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
    case na = "Non specificato"
}

let coloriVietati: [Colore: [Colore]] = [
    .bianco: [.crema, .beige],
    .nero: [.marrone, .bluNotte, .verdeScuro, .bordeaux],
    .crema: [.bianco, .beige],
    .beige: [.bianco, .crema]
]

var coloriConsentiti: [Colore: [Colore]] = [
    .rosso: [.bluNotte, .bluNavy, .fuxia, .viola, .grigio, .avio, .avioScuro, .bianco, .nero],
    .bordeaux: [.beige, .verdeFoglia, .rosa, .grigio, .avio, .avioScuro, .bianco],
    .rosa: [.avio, .viola, .fuxia, .blu, .bordeaux, .marrone, .grigio, .avio, .avioScuro, .bianco, .nero],
    .arancione: [.marroneScuro, .crema, .avioScuro, .bluNotte, .gialloUovo, .grigio, .avio, .avioScuro, .bianco, .nero],
    .gialloUovo: [.arancione, .bluNavy, .viola, .verdeOliva, .grigio, .avio, .avioScuro, .bianco, .nero],
    .giallo: [.viola, .verdeScuro, .grigio, .avio, .avioScuro, .bianco, .nero],
    .lime: [.verdeFoglia, .bluNotte, .beige, .grigio, .avio, .avioScuro, .bianco, .nero],
    .verdeFluo: [.beige, .giallo, .bluNotte, .grigio, .avio, .avioScuro, .bianco, .nero],
    .verdeFoglia: [.giallo, .verdeScuro, .bordeaux, .marroneScuro, .grigio, .avio, .avioScuro, .bianco, .nero],
    .verdeScuro: [.verdeFoglia, .beige, .giallo, .grigio, .avio, .avioScuro, .bianco],
    .verdeOliva: [.gialloUovo, .marrone, .marroneScuro, .crema, .grigio, .avio, .avioScuro, .bianco, .nero],
    .avio: [.rosso, .bordeaux, .rosa, .arancione, .gialloUovo, .giallo, .lime, .verdeFluo, .verdeFoglia, .verdeScuro, .verdeOliva,
            .avio, .avioScuro, .blu, .bluNavy, .bluNotte, .viola, .fuxia, .fuxiaFluo, .marrone, .marroneScuro, .crema, .beige,
            .marroneCammello, .celeste, .celesteScuro, .bianco, .grigio, .nero, .crema, .beige],
    .avioScuro: [.rosso, .bordeaux, .rosa, .arancione, .gialloUovo, .giallo, .lime, .verdeFluo, .verdeFoglia, .verdeScuro, .verdeOliva,
                 .avio, .avioScuro, .blu, .bluNavy, .bluNotte, .viola, .fuxia, .fuxiaFluo, .marrone, .marroneScuro, .crema, .beige,
                 .marroneCammello, .celeste, .celesteScuro, .bianco, .grigio, .nero, .crema, .beige],
    .blu: [.beige, .rosso, .rosa, .fuxia, .grigio, .avio, .avioScuro, .bianco, .nero],
    .bluNavy: [.beige, .rosso, .gialloUovo, .grigio, .avio, .avioScuro, .bianco],
    .bluNotte: [.avioScuro, .rosso, .verdeFluo, .lime, .grigio, .avio, .avioScuro, .bianco],
    .viola: [.giallo, .rosa, .gialloUovo, .rosso, .fuxiaFluo, .grigio, .avio, .avioScuro, .bianco, .nero],
    .fuxiaFluo: [.viola, .grigio, .rosa, .avio, .avioScuro, .bianco, .nero],
    .fuxia: [.blu, .rosso, .avio, .grigio, .avioScuro, .bianco, .nero],
    .marrone: [.verdeOliva, .marroneScuro, .marroneCammello, .rosa, .grigio, .avio, .avioScuro, .bianco],
    .marroneScuro: [.marrone, .marroneCammello, .verdeOliva, .verdeFoglia, .grigio, .avio, .avioScuro, .bianco],
    .grigio: [.rosso, .bordeaux, .rosa, .arancione, .gialloUovo, .giallo, .lime, .verdeFluo, .verdeFoglia, .verdeScuro, .verdeOliva,
              .avio, .avioScuro, .blu, .bluNavy, .bluNotte, .viola, .fuxia, .fuxiaFluo, .marrone, .marroneScuro, .crema, .beige,
              .marroneCammello, .celeste, .celesteScuro, .bianco, .nero],
    .celeste: [.arancione, .blu, .giallo, .grigio, .avio, .avioScuro, .bianco, .nero],
    .celesteScuro: [.grigio, .avio, .avioScuro, .bianco, .nero],
    .marroneCammello: [.bluNavy, .beige, .marrone, .marroneScuro, .grigio, .avio, .avioScuro, .bianco]
]
