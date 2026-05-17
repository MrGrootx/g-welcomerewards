import { MockItems } from "@/data/MockItems";
import { WelcomeItem } from "@/types";
import { fetchNui } from "@/utils/fetchNui";
import { isEnvBrowser } from "@/utils/misc"

export const getWelcomePackage = async () => {
    if (isEnvBrowser()) {
        await new Promise(resolve => setTimeout(resolve, 1000));
        return MockItems;
    }
    return fetchNui<WelcomeItem[]>('justgroot:g-welcome-rewards:getWelcomePackages');
}