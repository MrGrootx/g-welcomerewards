import { createSlice, PayloadAction } from "@reduxjs/toolkit";

const localizationKeys = {
  order_details: "Order Details",
} as const;

type LocalizationKeys = keyof typeof localizationKeys;
export type LocalizationsI = {
  [K in LocalizationKeys]: string;
};

const initialState: LocalizationsI = localizationKeys;

const LocalizationsSlice = createSlice({
  name: "Localizations",
  initialState,
  reducers: {
    setLocalization: (state, action: PayloadAction<LocalizationsI>) => {
      return action.payload;
    },
  },
});

export const { setLocalization } = LocalizationsSlice.actions;

export default LocalizationsSlice.reducer;
