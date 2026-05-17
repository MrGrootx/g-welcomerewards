import { MockItems, MockVehicles } from "@/data/MockItems";
import { WelcomeItem, WelcomeVehicle } from "@/types";
import { fetchNui } from "@/utils/fetchNui";
import { isEnvBrowser } from "@/utils/misc"

export const getWelcomePackage = async () => {
    if (isEnvBrowser()) {
        await new Promise(resolve => setTimeout(resolve, 1000));
        return MockItems;
    }
    return fetchNui<WelcomeItem[]>('justgroot:g-welcome-rewards:getWelcomePackages');
}

export const getWelcomeVehicles = async () => {
    if (isEnvBrowser()) {
        await new Promise(resolve => setTimeout(resolve, 1000));
        return MockVehicles;
    }
    return fetchNui<WelcomeVehicle>('justgroot:g-welcome-rewards:getWelcomeVehicle');
}

export const claimWelcomePackage = async () => {
    if (isEnvBrowser()) {
        await new Promise(resolve => setTimeout(resolve, 1000));
        return true;
    }
    return fetchNui<boolean>('justgroot:g-welcome-rewards:claimWelcomePackage');
}

export const claimWelcomeVehicle = async () => {
    if (isEnvBrowser()) {
        await new Promise(resolve => setTimeout(resolve, 1000));
        return true;
    }
    return fetchNui<boolean>('justgroot:g-welcome-rewards:claimWelcomeVehicle');
}