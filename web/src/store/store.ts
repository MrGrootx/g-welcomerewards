import { configureStore } from "@reduxjs/toolkit";
import localizationReducer from "./Localization-slice";
import { useSelector } from "react-redux";

export const store = configureStore({
  reducer: {
    localization: localizationReducer,
  },
});

export type RootState = ReturnType<typeof store.getState>;
export type AppDispatch = typeof store.dispatch;

const useLocalization = () => {
  const localization = useSelector((state: RootState) => state.localization);
  return localization;
};

export default useLocalization;
