import { useDispatch } from "react-redux";
import { LocalizationsI, setLocalization } from "../store/Localization-slice";
import { useNuiEvent } from "../hooks/useNuiEvent";



export const LocalizationInitializer = () => {
  const dispatch = useDispatch();
  useNuiEvent("justgroot-g-:localizations:g-welcomerewards", (data: LocalizationsI) => {
    dispatch(setLocalization(data));
  });
  return null;
};

export default LocalizationInitializer;
