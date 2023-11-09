module QueriesHelper
    def get_one_week
        today = Date.today
        # 過去一週間の日付を計算
        week_ago = today - 6 # 6日前から開始するため、6を引く
        return dates = (week_ago..today).to_a
    end

    def get_one_week_ago
        today = Date.today
        # 過去一週間の日付を計算
        week_ago = today - 6 # 6日前から開始するため、6を引く
        return week_ago
    end

    def get_one_month
        today = Date.today
        # 過去一週間の日付を計算
        month_ago = today - 31 # 6日前から開始するため、6を引く
        return dates = (month_ago..today).to_a
    end

    def get_one_month_ago
        today = Date.today
        # 過去一週間の日付を計算
        month_ago = today - 31 # 6日前から開始するため、6を引く
        return month_ago
    end

    def get_ranks_last(query)
        ranks = query.ranks
        ranks_last = ranks.last
        if ranks_last.present? && ranks_last.gsp_rank.present?
            return ranks_last.gsp_rank
        elsif ranks_last.present? && ranks_last.created_at.present?
            return "圏外"
        else
            return ""
        end
    end

    def get_rank_comparison(query,comparison_day)
        ranks = query.ranks
        ranks_last = ranks.last
        ranks_day_comparison = ranks.find_by(created_at: comparison_day.beginning_of_day..comparison_day.end_of_day)
        if ranks_last && ranks_last.gsp_rank.present? && ranks_day_comparison && ranks_day_comparison.gsp_rank.present?
            ranks_last.gsp_rank - ranks_day_comparison.gsp_rank
        else
            ""
        end
    end

    def get_comparison_month(query)
    end

    def get_detection_url_last(query)
        ranks = query.ranks
        ranks_last = ranks.last
        if ranks_last.present?
            return ranks_last.detection_url
        else
            return ""
        end
    end

    def date_to_search_gsp_rank(id,date_to_search)
        rank = Rank.find_by(query_id:id,created_at: date_to_search.beginning_of_day..date_to_search.end_of_day)
        if rank.present? && rank.gsp_rank.present?
            return rank.gsp_rank
        elsif rank.present? && rank.created_at.present?
            return "圏外"
        else
            return "未計測"
        end
    end
end