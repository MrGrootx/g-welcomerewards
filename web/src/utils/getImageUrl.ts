import { RewardCatalogItem } from '@/types'
import { isEnvBrowser } from '@/utils/misc'

export const getImageUrl = (
    item: RewardCatalogItem,
    inventoryImagePath?: string,
) => {
    if (item.type === 'item') {
        if (isEnvBrowser()) return '/images/reward.png'
        const base = inventoryImagePath?.trim()
        return base ? `nui://${base}/${item.image}` : '/images/reward.png'
    }

    if (item.type === 'cash') {
        return 'images/cash.webp'
    }

    if (item.type === 'bank') {
        return 'images/bank.webp'
    }

    return 'images/popbox.png'
}
