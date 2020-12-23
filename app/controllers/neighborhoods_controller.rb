class NeighborhoodsController < ApplicationController

    def index
        render_neighborhood
    end

    def details
        render_neighborhood_details
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
        params['ids'] ? filtered_neighborhoods : all_neighborhoods
    end

    def render_neighborhood_details
        render json: all_neighborhoods, except: [:created_at, :updated_at]
    end

    def render_neighborhood
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
end
