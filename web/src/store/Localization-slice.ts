import { createSlice, PayloadAction } from "@reduxjs/toolkit";
import { RootState } from "./store";
import { useSelector } from "react-redux";

const localizationKeys = {
  new_citizen_package: "New Citizen Package",
  welcome_to_the_city: "Welcome to the city. Claim your starter rewards and begin your journey.",
  collect_package: "Collect Package",
  starter_package: "Starter Package",
  loading_rewards: "Loading rewards...",
  rewards_ready_to_claim: "rewards ready to claim",
  speed: "Speed",
  acceleration: "Acceleration",
  braking: "Braking",
  grip: "Grip",
  seats: "seats",
  claim_vehicle: "Claim Vehicle",
  starter_vehicle: "Starter Vehicle",
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

export const useLocalization = () => {
  return useSelector((state: RootState) => state.localization);
};  