export interface SystemSettings {
    Currency: string;
    position: "left" | "right" | "center";
    inventoryImagePath?: string;
}

export type RewardCatalogItem = WelcomeItem;

export interface WelcomeItem {
    name: string;
    Label: string;
    quantity: number;
    image: string;
    type: "item" | "cash" | "bank";
}

export interface WelcomeVehicle {
    label: string;
    class: string;
    seats: number;
    stats: {
        speed: number;
        acceleration: number;
        braking: number;
        grip: number;
    },
    imageUrl: string;
}