class NeighborhoodsController < ApplicationController

    def index
        render_neighborhoods
    end

    def details
        render_all_neighborhoods_details
    end

    private

    def all_neighborhoods
        Neighborhood.all
    end

    def get_ids_from_params
        params['ids'].split('-')
    end

    def filtered_neighborhoods
        get_ids_from_params.map { |id| Neighborhood.find_by_id(id) }
    end

    def all_queried_neighborhoods
        # if we receive params from request, only include those neighborhoods, otherwise grab all neighborhoods
        params['ids'] ? filtered_neighborhoods : all_neighborhoods
    end

    def render_all_neighborhoods_details
        render json: all_neighborhoods, except: [:created_at, :updated_at]
    end

    def render_neighborhoods
        # intuitive data structure, slower load time than serialized json
        render json: all_queried_neighborhoods, 
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

    def render_neighborhoods_with_serializer
        # doesn't render the apartment details & less intuitive file structure
        # revisit/refactor later
        render json: NeighborhoodSerializer.new(all_queried_neighborhoods).serializable_hash
    end
end
