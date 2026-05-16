import * as React from "react"
import { cva, type VariantProps } from "class-variance-authority"

import { cn } from "@/lib/utils"

const badgeVariants = cva(
  "inline-flex items-center rounded-md border px-2.5 py-0.5 text-xs font-semibold transition-colors focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2",
  {
    variants: {
      variant: {
        default:
          "border-transparent bg-primary text-primary-foreground shadow hover:bg-primary/80",
        secondary:
          "border-transparent bg-secondary text-secondary-foreground hover:bg-secondary/80",
        destructive:
          "border-transparent bg-destructive text-destructive-foreground shadow hover:bg-destructive/80",
        outline: "text-foreground",
        light: "",
      },
      color: {
        default: "",
        red: "",
        green: "",
        blue: "",
        yellow: "",
        purple: "",
        orange: "",
      },
    },
    compoundVariants: [
      {
        variant: "light",
        color: "red",
        class: "border-transparent bg-red-500/20 text-red-600 dark:text-red-400 hover:bg-red-500/30",
      },
      {
        variant: "light",
        color: "green",
        class: "border-transparent bg-green-500/20 text-green-600 dark:text-green-400 hover:bg-green-500/30",
      },
      {
        variant: "light",
        color: "blue",
        class: "border-transparent bg-blue-500/20 text-blue-600 dark:text-blue-400 hover:bg-blue-500/30",
      },
      {
        variant: "light",
        color: "yellow",
        class: "border-transparent bg-yellow-500/20 text-yellow-600 dark:text-yellow-400 hover:bg-yellow-500/30",
      },
      {
        variant: "light",
        color: "purple",
        class: "border-transparent bg-purple-500/20 text-purple-600 dark:text-purple-400 hover:bg-purple-500/30",
      },
      {
        variant: "light",
        color: "orange",
        class: "border-transparent bg-orange-500/20 text-orange-600 dark:text-orange-400 hover:bg-orange-500/30",
      },
      {
        variant: "default",
        color: "red",
        class: "border-transparent bg-red-500 text-white hover:bg-red-500/80",
      },
      {
        variant: "default",
        color: "green",
        class: "border-transparent bg-green-500 text-white hover:bg-green-500/80",
      },
      {
        variant: "default",
        color: "blue",
        class: "border-transparent bg-blue-500 text-white hover:bg-blue-500/80",
      },
      {
        variant: "default",
        color: "yellow",
        class: "border-transparent bg-yellow-500 text-white hover:bg-yellow-500/80",
      },
      {
        variant: "default",
        color: "purple",
        class: "border-transparent bg-purple-500 text-white hover:bg-purple-500/80",
      },
      {
        variant: "default",
        color: "orange",
        class: "border-transparent bg-orange-500 text-white hover:bg-orange-500/80",
      },
    ],
    defaultVariants: {
      variant: "default",
      color: "default",
    },
  }
)

export interface BadgeProps
  extends React.HTMLAttributes<HTMLDivElement>,
    VariantProps<typeof badgeVariants> {
      variant?: "default" | "secondary" | "destructive" | "outline" | "light";
      color?: "default" | "red" | "green" | "blue" | "yellow" | "purple" | "orange";
    }

function Badge({ className, variant, color, ...props }: BadgeProps) {
  return (
    <div className={cn(badgeVariants({ variant, color }), className)} {...props} />
  )
}

export { Badge, badgeVariants }
