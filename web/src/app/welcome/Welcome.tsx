import { Button } from '@/components/ui/button'
import { Separator } from '@/components/ui/separator'
import { Car, Package } from 'lucide-react'

const vehicleSpecs = [
    { label: 'Top Speed', value: 98 },
    { label: 'Acceleration', value: 89 },
    { label: 'Braking', value: 82 },
    { label: 'Handling', value: 91 },
]

const Welcome = () => {
    return (
        <div className='p-4 font-Outfit'>
            <div>
                <h4 className='font-semibold text-foreground '>New Citizen Package</h4>
                <p className='font-semibold text-xs'>Welcome to the city. Claim your starter rewards and begin your journey.</p>
            </div>
            <Separator className='my-2' />
            <div className='w-full'>
                <div className='grid grid-cols-4 gap-2'>
                    {Array.from({ length: 4 }).map((_, index) => (
                        <div
                            key={index}
                            className="group flex flex-col gap-2 rounded-lg border bg-card p-2 text-xs shadow-sm"
                        >
                            <div className="group/image aspect-square w-full overflow-hidden rounded-md bg-muted/75 relative">
                                <div className="flex h-full items-center justify-center">
                                    <img
                                        src={'images/reward.png'}
                                        alt=""
                                        className="h-[90px] w-[90px] object-cover object-center transition-transform duration-300 ease-out will-change-transform group-hover/image:scale-[1.06] group-hover/image:brightness-110 group-hover/image:rotate-3"
                                    />
                                </div>
                            </div>
                        </div>
                    ))}
                </div>
                <div className='w-full flex justify-end mt-2'>
                    <Button size={'sm'}><Package />Collect</Button>
                </div>
            </div>
            <Separator className='my-2' />
            <div>
                <h4 className='font-semibold text-foreground'>Starter Vehicle</h4>
                <p className='font-semibold text-xs'>Your first ride in the city. Claim it and hit the road.</p>
            </div>
            <div className='mt-2 flex gap-3 rounded-lg border bg-card p-2 text-xs shadow-sm'>
                <div className='flex w-[42%] shrink-0 items-center justify-center overflow-hidden rounded-md bg-muted/75 p-2'>
                    <img
                        src='https://docs.fivem.net/vehicles/t20.webp'
                        alt='T20'
                        className='h-auto w-full object-contain'
                    />
                </div>
                <div className='flex min-w-0 flex-1 flex-col justify-between gap-2'>
                    <div>
                        <p className='font-semibold text-foreground'>Progen T20</p>
                        <p className='text-muted-foreground'>Super · 2 seats</p>
                        <div className='mt-2 space-y-1.5'>
                            {vehicleSpecs.map((spec) => (
                                <div key={spec.label}>
                                    <div className='mb-0.5 flex justify-between text-[10px]'>
                                        <span className='text-muted-foreground'>{spec.label}</span>
                                        <span className='font-medium text-foreground'>{spec.value}%</span>
                                    </div>
                                    <div className='h-1 overflow-hidden rounded-full bg-muted'>
                                        <div
                                            className='h-full rounded-full bg-foreground/80'
                                            style={{ width: `${spec.value}%` }}
                                        />
                                    </div>
                                </div>
                            ))}
                        </div>
                    </div>
                    <Button size='sm' className='w-full'>
                        <Car className='size-3.5' />
                        Collect
                    </Button>
                </div>
            </div>
        </div>
    )
}

export default Welcome
