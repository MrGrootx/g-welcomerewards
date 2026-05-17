import { createSlice, PayloadAction } from "@reduxjs/toolkit";
import { SystemSettings } from "../types";

type WelcomeState = {
    systemSettings: SystemSettings;
}

const initialState: WelcomeState = {
    systemSettings: {} as SystemSettings
}

const welcomeSlice = createSlice({
    name: "welcome",
    initialState: initialState as WelcomeState,
    reducers: {
        setSystemSettings: (state, action: PayloadAction<SystemSettings>) => {
            state.systemSettings = action.payload;
        }
    },
});

export const {
    setSystemSettings,
} = welcomeSlice.actions;

export default welcomeSlice.reducer;
