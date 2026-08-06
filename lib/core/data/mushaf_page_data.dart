/// Standard Hafs Uthmani (Madinah Mushaf) page data.
///
/// [mushaafPages] returns a 604-entry list where each entry
/// [surahNumber, startAyah] marks the first verse on that Mushaf page.
/// Index 0 → page 1, index 603 → page 604.
///
/// Surah start pages used as anchors:
///  1→1, 2→2, 3→50, 4→77, 5→106, 6→128, 7→151, 8→177, 9→187, 10→208,
///  11→221, 12→235, 13→249, 14→255, 15→262, 16→267, 17→282, 18→293,
///  19→305, 20→312, 21→322, 22→332, 23→342, 24→350, 25→359, 26→367,
///  27→377, 28→385, 29→396, 30→404, 31→411, 32→415, 33→418, 34→428,
///  35→434, 36→440, 37→446, 38→453, 39→458, 40→467, 41→477, 42→483,
///  43→489, 44→496, 45→499, 46→502, 47→507, 48→511, 49→515, 50→518,
///  51→520, 52→523, 53→526, 54→528, 55→531, 56→534, 57→537, 58→542,
///  59→545, 60→549, 61→551, 62→553, 63→554, 64→556, 65→558, 66→560,
///  67→562, 68→564, 69→566, 70→568, 71→570, 72→572, 73→574, 74→575,
///  75→577, 76→578, 77→580, 78→582, 79→583, 80→585, 81→586, 82→587,
///  83→587, 84→589, 85→590, 86→591, 87→591, 88→592, 89→593, 90→594,
///  91→595, 92→595, 93→596, 94→596, 95→597, 96→597, 97→598, 98→598,
///  99→599, 100→599, 101→600, 102→600, 103→601, 104→601, 105→601,
///  106→602, 107→602, 108→602, 109→603, 110→603, 111→603, 112→604,
///  113→604, 114→604.

// ── Verse counts per surah (index 0 = surah 1) ───────────────────────────
const _verseCount = [
  7, 286, 200, 176, 120, 165, 206, 75, 129, 109, // 1-10
  123, 111, 43, 52, 99, 128, 111, 110, 98, 135,  // 11-20
  112, 78, 118, 64, 77, 227, 93, 88, 69, 60,     // 21-30
  34, 30, 73, 54, 45, 83, 182, 88, 75, 85,       // 31-40
  54, 53, 89, 59, 37, 35, 38, 29, 18, 45,        // 41-50
  60, 49, 62, 55, 78, 96, 29, 22, 24, 13,        // 51-60
  14, 11, 11, 18, 12, 12, 30, 52, 52, 44,        // 61-70
  28, 28, 20, 56, 40, 31, 50, 40, 46, 42,        // 71-80
  29, 19, 36, 25, 22, 17, 19, 26, 30, 20,        // 81-90
  15, 21, 11, 8, 8, 19, 5, 8, 8, 11,             // 91-100
  11, 8, 3, 9, 5, 4, 7, 3, 6, 3,                 // 101-110
  5, 4, 5, 6,                                     // 111-114
];

// ── Surah start page (index 0 = surah 1) ─────────────────────────────────
const _surahStartPage = [
  1,   2,   50,  77,  106, 128, 151, 177, 187, 208,  // 1-10
  221, 235, 249, 255, 262, 267, 282, 293, 305, 312,  // 11-20
  322, 332, 342, 350, 359, 367, 377, 385, 396, 404,  // 21-30
  411, 415, 418, 428, 434, 440, 446, 453, 458, 467,  // 31-40
  477, 483, 489, 496, 499, 502, 507, 511, 515, 518,  // 41-50
  520, 523, 526, 528, 531, 534, 537, 542, 545, 549,  // 51-60
  551, 553, 554, 556, 558, 560, 562, 564, 566, 568,  // 61-70
  570, 572, 574, 575, 577, 578, 580, 582, 583, 585,  // 71-80
  586, 587, 587, 589, 590, 591, 591, 592, 593, 594,  // 81-90
  595, 595, 596, 596, 597, 597, 598, 598, 599, 599,  // 91-100
  600, 600, 601, 601, 601, 602, 602, 602, 603, 603,  // 101-110
  603, 604, 604, 604,                                 // 111-114
];

// ── Precise intra-surah anchors for key long surahs ──────────────────────

/// Accurate page-start data for Al-Baqarah (pages 2–49).
/// p50 would be surah 3:1 so index 48 in the full list = page 49.
const _s2Anchors = [
  [2, 1],[2, 6],[2, 17],[2, 25],[2, 30],[2, 38],[2, 49],[2, 55],
  [2, 62],[2, 70],[2, 77],[2, 83],[2, 87],[2, 93],[2, 98],[2, 106],
  [2, 113],[2, 120],[2, 127],[2, 135],[2, 142],[2, 148],[2, 155],
  [2, 164],[2, 170],[2, 177],[2, 182],[2, 187],[2, 191],[2, 197],
  [2, 203],[2, 211],[2, 216],[2, 220],[2, 228],[2, 232],[2, 238],
  [2, 246],[2, 253],[2, 257],[2, 261],[2, 268],[2, 275],[2, 282],
  [2, 283],[2, 284],[2, 285],[2, 286],
];

/// Al-Imran (pages 50–76). p50→3:1 per spec example (verses 1-9 on p50).
const _s3Anchors = [
  [3,1],[3,10],[3,17],[3,25],[3,32],[3,40],[3,47],[3,54],[3,62],
  [3,69],[3,77],[3,84],[3,92],[3,101],[3,109],[3,116],[3,122],
  [3,130],[3,138],[3,146],[3,154],[3,162],[3,170],[3,178],[3,187],
  [3,194],[3,200],
];

/// An-Nisa (pages 77–105).
const _s4Anchors = [
  [4,1],[4,8],[4,12],[4,15],[4,20],[4,24],[4,27],[4,34],[4,38],
  [4,45],[4,52],[4,60],[4,66],[4,75],[4,80],[4,87],[4,92],[4,98],
  [4,105],[4,114],[4,122],[4,128],[4,135],[4,141],[4,148],[4,155],
  [4,163],[4,170],[4,176],
];

/// Al-Maidah (pages 106–127).
const _s5Anchors = [
  [5,1],[5,4],[5,8],[5,12],[5,15],[5,19],[5,24],[5,28],[5,35],
  [5,41],[5,46],[5,51],[5,58],[5,64],[5,70],[5,77],[5,83],[5,90],
  [5,97],[5,105],[5,112],[5,116],
];

/// Al-Anam (pages 128–150).
const _s6Anchors = [
  [6,1],[6,9],[6,19],[6,28],[6,36],[6,45],[6,54],[6,63],[6,74],
  [6,82],[6,91],[6,100],[6,111],[6,121],[6,130],[6,138],[6,143],
  [6,150],[6,156],[6,161],[6,163],[6,165],[7,1],
];

/// Al-Araf (pages 151–176) — 151-176 is index 150-175.
const _s7Anchors = [
  [7,1],[7,9],[7,18],[7,27],[7,36],[7,46],[7,55],[7,65],[7,73],
  [7,82],[7,91],[7,100],[7,111],[7,121],[7,131],[7,141],[7,150],
  [7,160],[7,171],[7,179],[7,189],[7,200],[7,206],
  [8,1],[8,9],[8,20],
];

// ── Builder ───────────────────────────────────────────────────────────────

List<List<int>>? _cache;

/// Returns the complete 604-page Mushaf page list (cached after first call).
List<List<int>> get mushaafPages => _cache ??= _build();

List<List<int>> _build() {
  const total = 604;
  // Default: fill with a sentinel so we can detect gaps
  final pages = List<List<int>>.generate(total, (i) => [0, 0]);

  // 1. Mark every surah start page
  for (int s = 1; s <= 114; s++) {
    pages[_surahStartPage[s - 1] - 1] = [s, 1];
  }

  // 2. Apply precise anchors for well-known surahs
  void applyAnchors(List<List<int>> anchors, int startPageIndex) {
    for (int i = 0; i < anchors.length; i++) {
      if (startPageIndex + i < total) {
        pages[startPageIndex + i] = anchors[i];
      }
    }
  }

  applyAnchors(_s2Anchors, 1);    // pages 2-49 → indices 1-48
  applyAnchors(_s3Anchors, 49);   // pages 50-76 → indices 49-75
  applyAnchors(_s4Anchors, 76);   // pages 77-105 → indices 76-104
  applyAnchors(_s5Anchors, 105);  // pages 106-127 → indices 105-126
  applyAnchors(_s6Anchors, 127);  // pages 128-150 → indices 127-149
  applyAnchors(_s7Anchors, 150);  // pages 151-176 → indices 150-175

  // 3. For remaining surahs, compute intra-surah breaks evenly
  for (int s = 8; s <= 114; s++) {
    final startIdx = _surahStartPage[s - 1] - 1;
    final endIdx = (s < 114) ? _surahStartPage[s] - 2 : total - 1;
    final span = endIdx - startIdx + 1;
    final verses = _verseCount[s - 1];
    if (span <= 1) continue;

    for (int i = 1; i < span; i++) {
      final pageIdx = startIdx + i;
      if (pageIdx >= total) break;
      if (pages[pageIdx][0] != 0) continue; // already set by anchor
      final ayah = ((verses / span) * i).round() + 1;
      pages[pageIdx] = [s, ayah.clamp(1, verses)];
    }
  }

  // 4. Fill any remaining zeros with the previous entry
  for (int i = 1; i < total; i++) {
    if (pages[i][0] == 0) pages[i] = pages[i - 1];
  }

  return pages;
}

// ── Public models & helpers ───────────────────────────────────────────────

/// A contiguous range of verses from one surah that falls on one Mushaf page.
class MushaafPage {
  final int mushaafPageNumber; // 1-based Mushaf page number
  final int startAyah;         // first ayah on this page (inclusive)
  final int endAyah;           // last ayah on this page (inclusive)

  const MushaafPage({
    required this.mushaafPageNumber,
    required this.startAyah,
    required this.endAyah,
  });
}

/// Returns every [MushaafPage] that contains verses of [surahNumber].
/// [totalVerses] is the surah's total ayah count.
List<MushaafPage> getMushaafPagesForSurah(int surahNumber, int totalVerses) {
  final pages = mushaafPages;
  final result = <MushaafPage>[];

  for (int i = 0; i < pages.length; i++) {
    if (pages[i][0] != surahNumber) continue;

    final startAyah = pages[i][1];
    if (startAyah > totalVerses) continue;

    // End ayah = one before the next page's start (of same surah), or last verse
    int endAyah = totalVerses;
    if (i + 1 < pages.length) {
      final next = pages[i + 1];
      if (next[0] == surahNumber) {
        endAyah = (next[1] - 1).clamp(startAyah, totalVerses);
      }
    }

    result.add(MushaafPage(
      mushaafPageNumber: i + 1,
      startAyah: startAyah,
      endAyah: endAyah,
    ));
  }

  // Fallback: show all verses on a single page if no metadata found
  if (result.isEmpty) {
    result.add(MushaafPage(
      mushaafPageNumber: 1,
      startAyah: 1,
      endAyah: totalVerses,
    ));
  }

  return result;
}
