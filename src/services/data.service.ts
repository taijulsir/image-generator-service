import { ImageRequest } from '../types';

/**
 * Service to handle data fetching and transformation for image generation
 */
export const dataService = {
    /**
     * Fetches image data based on event and fixture IDs
     * Currently returns mock data as requested
     */
    async fetchImageData(eventId: number, eventType: string, fixtureId: number): Promise<ImageRequest> {
        // In a real application, you would fetch this from an external API or database
        // based on the provided IDs.

        // Mock data logic
        return {
            id: eventId,
            type: "goal",
            title: "GOAL! Man City Vs ARS",
            gw: "7",
            data: {
                home_team: {
                    name: "Manchester City",
                    logo: "https://upload.wikimedia.org/wikipedia/en/e/eb/Manchester_City_FC_badge.svg",
                    short_name: "MCI"
                },
                away_team: {
                    name: "Arsenal",
                    logo: "https://upload.wikimedia.org/wikipedia/en/5/53/Arsenal_FC.svg",
                    short_name: "ARS"
                },
                team_win: "Manchester City",
                club_name: "Premier League",
                club_logo: "https://brandlogos.net/wp-content/uploads/2021/10/Premier-League-logo-symbol.png",
                goals: 1,
                scorers: []
            }
        };
    }
};
