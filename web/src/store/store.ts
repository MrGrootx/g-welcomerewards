import { configureStore } from "@reduxjs/toolkit";
import localizationReducer from "./Localization-slice";
import { useSelector } from "react-redux";
import welcomeReducer from "./Welcome-slice";

export const store = configureStore({
  reducer: {
    localization: localizationReducer,
    welcome: welcomeReducer,
  },
});

export type RootState = ReturnType<typeof store.getState>;
export type AppDispatch = typeof store.dispatch;

const useLocalization = () => {
  const localization = useSelector((state: RootState) => state.localization);
  return localization;
};

export const useWelcome = () => {
  const welcome = useSelector((state: RootState) => state.welcome);
  return welcome;
};
