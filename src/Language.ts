export const Language = {
  English: "en",
  Arabic: "ar",
  Azerbaijani: "az",
  Belarusian: "be",
  Georgian: "ka",
  Korean: "ko",
  Latvian: "lv",
  Lithuanian: "lt",
  Punjabi: "pa",
  Russian: "ru",
  Sanskrit: "sa",
  Sindhi: "sd",
  Thai: "th",
  Turkish: "tr",
  Ukrainian: "uk",
  Urdu: "ur",
  Uyghur: "ug",
  NON: "NON",
};

export type LanguageCode = typeof Language[keyof typeof Language];
