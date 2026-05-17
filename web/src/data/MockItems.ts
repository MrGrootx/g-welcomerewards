import { WelcomeItem, WelcomeVehicle } from "@/types";

export const MockItems: WelcomeItem[] = [
    {
        name: "water",
        Label: "Water",
        quantity: 10,
        image: "water.png",
        type: "item",
    },
    {
        name: "burger",
        Label: "Burger",
        quantity: 8,
        image: "burger.png",
        type: "item",
    },
    {
        name: "phone",
        Label: "Phone",
        quantity: 1,
        image: "phone.png",
        type: "item",
    },
    {
        name: "radio",
        Label: "Radio",
        quantity: 1,
        image: "radio.png",
        type: "item",
    },
    {
        name: "repairkit",
        Label: "Repair Kit",
        quantity: 2,
        image: "repairkit.png",
        type: "item",
    },
    {
        name: "bandage",
        Label: "Bandage",
        quantity: 5,
        image: "bandage.png",
        type: "item",
    },
    {
        name: "lockpick",
        Label: "Lockpick",
        quantity: 2,
        image: "lockpick.png",
        type: "item",
    },
    {
        name: "cash",
        Label: "Cash",
        quantity: 5000,
        image: "cash.png",
        type: "cash",
    },
];

export const MockVehicles: WelcomeVehicle = {
    label: "Progen T20",
    class: "Super Class",
    seats: 4,
    stats: {
        speed: 98,
        acceleration: 89,
        braking: 82,
        grip: 91,
    },
    imageUrl: "https://docs.fivem.net/vehicles/t20.webp",
}