class NeighborhoodsController < ApplicationController

    def index
        if params["ids"]
            neighborhoods = filtered_neighborhoods
        else
            neighborhoods = Neighborhood.all
        end

        render_neighborhood_collection(neighborhoods)
    end

    private

    def filtered_neighborhoods
        get_ids_from_params.map { |id| Neighborhood.find_by_id(id) }
    end

    def get_ids_from_params
        params['ids'].split('-')
    end

    def render_neighborhood_collection(collection)
        render json: collection, 
            except: [:created_at, :updated_at],
            include: { 
                apartments: {
                    except: [:created_at, :updated_at, :neighborhood_id],
                    include: {
                        images: {
                            only: :url
                        }
                    }
                }
            }
    end
end
