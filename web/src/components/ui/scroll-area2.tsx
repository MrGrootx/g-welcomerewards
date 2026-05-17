"use client"

import * as React from "react"
import * as ScrollAreaPrimitive from "@radix-ui/react-scroll-area"

import { cn } from "@/lib/utils"

function ScrollArea2({
  className,
  children,
  offset,
  showScrollbar = true,
  ...props
}: React.ComponentProps<typeof ScrollAreaPrimitive.Root> & {
  offset?: boolean
  showScrollbar?: boolean
}) {
  return (
    <ScrollAreaPrimitive.Root
      data-slot="scroll-area"
      className={cn("relative overflow-hidden", className)}
      {...props}
    >
      <ScrollAreaPrimitive.Viewport
        data-slot="scroll-area-viewport"
        className="focus-visible:ring-ring/50 h-full w-full rounded-[inherit] transition-[color,box-shadow] outline-none focus-visible:ring-[3px] focus-visible:outline-1 [&>div]:block"
        onWheel={(e) => {
          e.stopPropagation();
        }}
      >
        {offset ? <div className="pr-3 pb-3">{children}</div> : children}
      </ScrollAreaPrimitive.Viewport>
      {showScrollbar && <ScrollBar2 />}
      <ScrollAreaPrimitive.Corner />
    </ScrollAreaPrimitive.Root>
  )
}

function ScrollBar2({
  className,
  orientation = "vertical",
  ...props
}: React.ComponentProps<typeof ScrollAreaPrimitive.ScrollAreaScrollbar>) {
  return (
    <ScrollAreaPrimitive.ScrollAreaScrollbar
      data-slot="scroll-area-scrollbar"
      orientation={orientation}
      className={cn(
        "flex touch-none p-px transition-colors select-none z-10",
        orientation === "vertical" &&
          "h-full w-2.5 border-l border-l-transparent right-0",
        orientation === "horizontal" &&
          "h-2.5 flex-col border-t border-t-transparent bottom-0",
        className
      )}
      {...props}
    >
      <ScrollAreaPrimitive.ScrollAreaThumb
        data-slot="scroll-area-thumb"
        className="bg-border relative flex-1 rounded-full z-10"
      />
    </ScrollAreaPrimitive.ScrollAreaScrollbar>
  )
}

export { ScrollArea2, ScrollBar2 }