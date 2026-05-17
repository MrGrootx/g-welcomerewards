import { Badge } from '@/components/ui/badge'
import { Button } from '@/components/ui/button'
import { ScrollArea2 } from '@/components/ui/scroll-area2'
import { Separator } from '@/components/ui/separator'
import { Skeleton } from '@/components/ui/skeleton'
import { useWelcome } from '@/store/store'
import { WelcomeItem, WelcomeVehicle } from '@/types'
import { getImageUrl } from '@/utils/getImageUrl'
import { useMutation, useQuery } from '@tanstack/react-query'
import { Activity, CircleGauge, Gauge, Loader2, Zap } from 'lucide-react'
import { useEffect, useRef, useState } from 'react'
import { claimWelcomePackage, claimWelcomeVehicle, getWelcomePackage, getWelcomeVehicles } from './server'
import { useLocalization } from '@/store/Localization-slice'

const SCROLL_ITEM_THRESHOLD = 8
const SKELETON_COUNT = 8


const RewardAmountLabel = ({
    item,
    currency = '$',
}: {
    item: WelcomeItem
    currency?: string
}) => {
    if (item.type === 'item') {
        return (
            <span className='mt-3 w-full truncate text-center text-[10px] text-foreground'>
                {item.quantity}x
            </span>
        )
    }

    return (
        <span className='mt-3 w-full truncate text-center text-[10px]'>
            <span className='font-semibold text-green-600 dark:text-green-400'>{currency}</span>
            <span className='font-medium text-foreground'>{item.quantity.toLocaleString()}</span>
        </span>
    )
}

const PackageItemCard = ({
    item,
    inventoryImagePath,
    currency,
}: {
    item: WelcomeItem
    inventoryImagePath?: string
    currency?: string
}) => (
    <div className='group flex flex-col overflow-hidden rounded-md border border-border/50 bg-card/80 p-1.5'>
        <div className='group/image relative aspect-square w-full overflow-hidden rounded-md bg-muted/50'>
            <div className='relative flex h-full items-center justify-center'>
                <img
                    src={getImageUrl(item, inventoryImagePath)}
                    alt={item.Label}
                    className='h-14 w-14 object-cover object-center transition-transform duration-300 ease-out will-change-transform group-hover/image:scale-[1.06] group-hover/image:brightness-110 group-hover/image:rotate-3'
                />
            </div>
            <div className='absolute inset-x-1.5 bottom-1.5 flex items-center justify-between gap-2'>
                <span className='mt-3 w-full truncate text-center text-[10px] text-foreground'>
                    {item.Label}
                </span>
            </div>
            <div className='absolute inset-x-1.5 top-1'>
                <RewardAmountLabel item={item} currency={currency} />
            </div>
        </div>
    </div>
)

const PackageGridSkeleton = () => (
    <div className='grid grid-cols-4 gap-2 p-2'>
        {Array.from({ length: SKELETON_COUNT }).map((_, index) => (
            <div
                key={index}
                className='flex flex-col overflow-hidden rounded-md border border-border/50 bg-card/80 p-1.5'
            >
                <Skeleton className='aspect-square w-full rounded-md' />
            </div>
        ))}
    </div>
)

const VehicleCardSkeleton = () => (
    <div className='mt-2 overflow-hidden rounded-lg border text-xs'>
        <div className='relative h-32 overflow-hidden bg-gradient-to-br from-muted via-muted/60 to-background'>
            <div className='absolute inset-0 bg-gradient-to-t from-card via-card/20 to-transparent' />
            <Skeleton className='absolute left-2.5 top-2.5 h-4 w-[72px] rounded-[4px]' />
            <div className='absolute bottom-2.5 left-2.5 right-2.5'>
                <Skeleton className='h-3.5 w-24' />
                <Skeleton className='mt-1 h-2.5 w-28' />
            </div>
            <Skeleton className='absolute right-2.5 bottom-2.5 h-7 w-[88px] rounded-sm' />
        </div>

        <div className='grid grid-cols-4 divide-x divide-border border-t bg-muted/30'>
            {Array.from({ length: 4 }).map((_, index) => (
                <div key={index} className='flex flex-col items-center gap-1 px-1 py-2.5'>
                    <Skeleton className='size-3 rounded-full' />
                    <Skeleton className='h-2.5 w-8' />
                    <Skeleton className='h-3 w-6' />
                </div>
            ))}
        </div>
    </div>
)

const VehicleCard = ({ vehicle }: { vehicle: WelcomeVehicle }) => {
    const L = useLocalization()
    const vehicleSpecs = [
        { label: L.speed, value: vehicle.stats.speed, icon: Gauge },
        { label: L.acceleration, value: vehicle.stats.acceleration, icon: Zap },
        { label: L.braking, value: vehicle.stats.braking, icon: Activity },
        { label: L.grip, value: vehicle.stats.grip, icon: CircleGauge },
    ]

    const { mutate: claimWelcomeVehicleMutation, isPending: isClaimingVehicle } = useMutation({
        mutationFn: claimWelcomeVehicle,
    })

    return (
        <div className='mt-2 overflow-hidden rounded-lg border text-xs'>
            <div className='relative h-32 overflow-hidden bg-gradient-to-br from-muted via-muted/60 to-background'>
                <img
                    src={vehicle.imageUrl}
                    alt={vehicle.label}
                    className='absolute inset-0 h-full w-full object-contain object-center p-3'
                />
                <div className='absolute inset-0 bg-gradient-to-t from-card via-card/20 to-transparent' />
                <Badge variant='light' color='blue' className='absolute left-2.5 top-2.5 px-2 py-0 text-[10px] rounded-[4px]'>
                    {L.starter_vehicle}
                </Badge>
                <div className='absolute bottom-2.5 left-2.5 right-2.5'>
                    <p className='text-sm font-semibold text-foreground'>{vehicle.label}</p>
                    <p className='text-[10px] text-muted-foreground'>{vehicle.class} · {vehicle.seats} {L.seats}</p>
                </div>
                <div className='absolute right-2.5 bottom-2.5'>
                    <Button size='sm' variant='default' className='h-7 rounded-sm text-xs z-50' disabled={isClaimingVehicle} onClick={() => claimWelcomeVehicleMutation()}>
                        {L.claim_vehicle}
                    </Button>
                </div>
            </div>

            <div className='grid grid-cols-4 divide-x divide-border border-t bg-muted/30'>
                {vehicleSpecs.map((spec) => {
                    const Icon = spec.icon
                    return (
                        <div key={spec.label} className='flex flex-col items-center gap-1 px-1 py-2.5'>
                            <Icon className='size-3 text-muted-foreground' />
                            <span className='text-[10px] text-muted-foreground'>{spec.label}</span>
                            <span className='text-xs font-semibold tabular-nums text-foreground'>{spec.value}</span>
                        </div>
                    )
                })}
            </div>
        </div>
    )
}

const Welcome = () => {
    const { systemSettings } = useWelcome()
    const L = useLocalization()

    const contentRef = useRef<HTMLDivElement>(null)
    const [needsScroll, setNeedsScroll] = useState(false)

    const { data: welcomePackage, isLoading } = useQuery({
        queryKey: ['welcome-package'],
        queryFn: getWelcomePackage,
    })
    const { data: welcomeVehicle, isLoading: isVehiclesLoading } = useQuery({
        queryKey: ['welcome-vehicles'],
        queryFn: getWelcomeVehicles,
    })

    const isPackageLoading = isLoading
    const isVehicleLoading = isVehiclesLoading
    useEffect(() => {
        const content = contentRef.current
        if (!content || isPackageLoading) {
            setNeedsScroll(false)
            return
        }

        const updateScroll = () => {
            setNeedsScroll((welcomePackage?.length ?? 0) > SCROLL_ITEM_THRESHOLD)
        }

        updateScroll()

        const observer = new ResizeObserver(updateScroll)
        observer.observe(content)

        return () => observer.disconnect()
    }, [welcomePackage, isPackageLoading])

    const packageGrid = (
        <div ref={contentRef} className='grid grid-cols-4 gap-2 p-2'>
            {welcomePackage?.map((item, index) => (
                <PackageItemCard
                    key={`${item.name}-${index}`}
                    item={item}
                    inventoryImagePath={systemSettings.inventoryImagePath}
                    currency={systemSettings.Currency}
                />
            ))}
        </div>
    )

    const { mutate: claimWelcomePackageMutation, isPending: isClaimingPackage } = useMutation({
        mutationFn: claimWelcomePackage,
    })
   
    return (
        <div className='p-4 font-Outfit'>
            <div>
                <h4 className='font-semibold text-foreground '>{L.new_citizen_package}</h4>
                <p className='font-semibold text-xs'>{L.welcome_to_the_city}</p>
            </div>
            <Separator className='my-2' />
            <div className='overflow-hidden rounded-lg border text-xs '>
                <div className='relative overflow-hidden bg-gradient-to-br from-muted via-muted/60 to-background px-2.5 py-2.5'>
                    <div className='flex items-center justify-between'>
                        <div>
                            <div className='absolute inset-0 bg-gradient-to-t from-card/40 via-transparent to-transparent' />
                            <Badge variant='light' color='purple' className='relative px-2 py-0 text-[10px] rounded-[4px]'>
                                {L.starter_package}
                            </Badge>
                            <p className='relative mt-1.5 text-[10px] text-muted-foreground'>
                                {isPackageLoading
                                    ? L.loading_rewards
                                    : `${welcomePackage?.length ?? 0} ${L.rewards_ready_to_claim}`}
                            </p>
                        </div>
                        <Button size='sm' variant={'default'} className='h-7 rounded-sm text-xs z-50' disabled={isClaimingPackage} onClick={() => claimWelcomePackageMutation()}>
                            {L.collect_package}
                        </Button>
                    </div>
                </div>

                {isPackageLoading ? (
                    <div className='border-t bg-muted/30'>
                        <PackageGridSkeleton />
                    </div>
                ) : needsScroll ? (
                    // @ts-ignore
                    <ScrollArea2 className='h-[228px] border-t bg-muted/30' type='never'>
                        {packageGrid}
                    </ScrollArea2>
                ) : (
                    <div className='border-t bg-muted/30'>{packageGrid}</div>
                )}
            </div>

            {isVehicleLoading ? (
                <VehicleCardSkeleton />
            ) : welcomeVehicle ? (
                <VehicleCard vehicle={welcomeVehicle} />
            ) : null}
        </div>
    )
}

export default Welcome
