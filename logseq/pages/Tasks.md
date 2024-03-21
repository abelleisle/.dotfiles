banner:: ../assets/banner_tasks.avif

- #### Task Management Overview: ((65d4fd19-5f49-49e0-85d6-14539c24b1f8))
- #+BEGIN_QUERY
  {
      :title
          [:h2 [:strong "🎯 Today"] [:span " or "] [:span.block-marker.DOING "DOING"]]
      :query
      [:find (pull ?b [*])
       :in $ ?day
       :where
          [?b :block/marker ?marker]
          [?b :block/page ?p]
          (or
              (and
                  [(contains? #{"TODO"} ?marker)]
                  [?p :block/journal? true]
                  [?p :block/journal-day ?d]
                  (not [?b :block/scheduled])
                  (not [?b :block/deadline])
                  [(== ?d ?day)]
              )
              (and
                  [(contains? #{"TODO" "LATER" "WAITING"} ?marker)]
                  (or
                      [?b :block/scheduled ?d]
                      [?b :block/deadline ?d])
                  [(== ?d ?day)]
              )
              (and
                  [(contains? #{"NOW", "DOING"} ?marker)]
                  [?d]
              )
          )
      ]
      :inputs [:today]
      :result-transform (
          fn [result] (
              sort-by (fn [h]
                  (get h :block/priority "Z")) result
              )
      )
      :breadcrumb-show? false
  }
  #+END_QUERY
- query-table:: false
  #+BEGIN_QUERY
  {:title [:h2 "🔥 Past Due"]
      :query
      [:find (pull ?b [*])
       :in $ ?day
       :where
          [?b :block/marker ?marker]
          [?b :block/page ?p]
          (or
              (and
                  [(contains? #{"TODO"} ?marker)]
                  ;(not [(contains? #{"DOING" "NOW"} ?marker)])
                  [?p :block/journal? true]
                  [?p :block/journal-day ?d]
                  (not [?b :block/scheduled])
                  (not [?b :block/deadline])
                  [(< ?d ?day)]
              )
              (and
                  [(contains? #{"TODO" "LATER" "WAITING" "DOING" "NOW"} ?marker)]
                  (or
                  [?b :block/scheduled ?d]
                  [?b :block/deadline ?d])
                  [(< ?d ?day)]
              )
          )
      ]
      :inputs [:today]
      :result-transform (
          fn [result] (
              sort-by (fn [h]
                  juxt
                      (get h :block/priority "Z")) result
                      (fn [r] (get-in r [:block/scheduled]))
                      (fn [r] (get-in r [:block/deadline]))
              )
      )
      :breadcrumb-show? false
  }
  #+END_QUERY
- #+BEGIN_QUERY
  {
      :title
          [:h2 [:strong "📅 This week"] [:span " or "] [:span.block-marker.LATER "LATER"] [:small [:sup "(without-date)"]]]
      :query [
          :find (pull ?block [*])
          :in $ ?start ?next
          :where
              (or-join [?block ?start ?next] 
                  (and
                      (or [?block :block/scheduled ?d] [?block :block/deadline ?d])
                      [(> ?d ?start)]
                      [(< ?d ?next)]
                  )
                  ;;
                  (and
                      [?block :block/marker ?m]
                      [(contains? #{"TODO"} ?m)]
                      [(missing? $ ?block :block/scheduled)]
                      [(missing? $ ?block :block/deadline)]
                  )
              )
      ]
      :inputs [:1d-after :7d-after]
      :breadcrumb-show? false
      :collapsed? false
  }
  #+END_QUERY
- #+BEGIN_QUERY
  {
    :title
        [:h2 [:strong "⏳ Waiting"]]
    :query [
        :find (pull ?block [*])
        :where
            [?block :block/marker ?marker]
            [(contains? #{"WAITING"} ?marker)]
    ]
    :breadcrumb-show? true
    :collapsed? false
  }
  #+END_QUERY
- #+BEGIN_QUERY
  {
    :title
        [:h2 [:strong "⌚ Later"]]
    :query [
        :find (pull ?block [*])
        :where
            [?block :block/marker ?marker]
            [(contains? #{"LATER"} ?marker)]
    ]
    :breadcrumb-show? false
    :collapsed? false
  }
  #+END_QUERY
- #### Old
  collapsed:: true
	- # Today
		- #+BEGIN_QUERY
		  {:breadcrumb-show? false,
		          :collapsed? false,
		          :group-by-page? true,
		          :inputs [:today],
		          :query [:find (pull ?b [*]) :in $ ?duetoday :where [?b :block/marker ?m]
		                  [(contains? #{"LATER" "TODO" "DOING" "NOW"} ?m)]
		                  [?b :block/scheduled ?d] [(= ?d ?duetoday)]],
		          :result-transform
		            (fn [result] (sort-by (fn [h] (get-in h [:block/scheduled])) result)),
		          :title "📤 SCHEDULED"}
		  #+END_QUERY
		- #+BEGIN_QUERY
		  {:breadcrumb-show? false,
		          :collapsed? false,
		          :group-by-page? true,
		          :inputs [:today],
		          :query [:find (pull ?b [*]) :in $ ?duetoday :where [?b :block/marker ?m]
		                  [(contains? #{"LATER" "TODO"} ?m)] (or [?b :block/scheduled ?d] [?b :block/deadline ?d])
		                  [(< ?d ?duetoday)]],
		          :result-transform
		            (fn [result] (sort-by (fn [h] (get-in h [:block/scheduled])) result)),
		          :title "🏃 MISSED"}
		  #+END_QUERY
		- #+BEGIN_QUERY
		  {
		      :title
		          [[:strong "⏰ Today"] [:span " or "] [:span.block-marker.DOING "DOING"]]
		      :query [
		          :find (pull ?block [*])
		          :in $ ?day
		          :where
		              [?block :block/marker ?m]
		              (or-join [?block ?day ?m] 
		                  (and
		                      [(contains? #{"TODO" "LATER"} ?m)]
		                      (or [?block :block/scheduled ?d] [?block :block/deadline ?d])
		                      [(= ?d ?day)]
		                  )
		                  ;;
		                  (and
		                      [(contains? #{"DOING" "NOW"} ?m)]
		                      ;[(missing? $ ?block :block/scheduled)]
		                      ;[(missing? $ ?block :block/deadline)]
		                  )
		              )
		      ]
		      :inputs [:today]
		      :breadcrumb-show? false
		      :collapsed? false
		  }
		  #+END_QUERY
	- # Tomorrow
		- #+BEGIN_QUERY
		  {
		      :title
		          [:strong "🌞 Tomorrow"]
		      :query [
		          :find (pull ?block [*])
		          :in $ ?day
		          :where
		              [?block :block/marker ?m]
		              [(contains? #{"TODO" "LATER"} ?m)]
		              (or [?block :block/scheduled ?d] [?block :block/deadline ?d])
		              [(= ?d ?day)]
		      ]
		      :inputs [:1d-after]
		      :breadcrumb-show? false
		      :collapsed? false
		  }
		  #+END_QUERY
	- # Later
		- #+BEGIN_QUERY
		  {
		      :title
		          [[:strong "📅 This week"] [:span " or "] [:span.block-marker.LATER "LATER"] [:sup "(without-date)"]]
		      :query [
		          :find (pull ?block [*])
		          :in $ ?start ?next
		          :where
		              (or-join [?block ?start ?next] 
		                  (and
		                      (or [?block :block/scheduled ?d] [?block :block/deadline ?d])
		                      [(> ?d ?start)]
		                      [(< ?d ?next)]
		                  )
		                  ;;
		                  (and
		                      [?block :block/marker ?m]
		                      [(contains? #{"TODO"} ?m)]
		                      [(missing? $ ?block :block/scheduled)]
		                      [(missing? $ ?block :block/deadline)]
		                  )
		              )
		      ]
		      :inputs [:1d-after :7d-after]
		      :breadcrumb-show? false
		      :collapsed? false
		  }
		  #+END_QUERY
		- collapsed:: true
		  #+BEGIN_QUERY
		  {
		    :title
		        [:strong "⏳ Waiting"]
		    :query [
		        :find (pull ?block [*])
		        :where
		            [?block :block/marker ?marker]
		            [(contains? #{"WAITING"} ?marker)]
		    ]
		    :breadcrumb-show? false
		    :collapsed? true
		  }
		  #+END_QUERY
	- # Past Due
		- query-properties:: [:page :block]
		  #+BEGIN_QUERY
		  {:title [:h3 "🔥 Past scheduled"]
		   :query [:find (pull ?b [*])
		     :in $ ?day  ; ?day is the name for the first value in inputs further down.
		     :where
		       [?b :block/marker "TODO"]  ; Using TODO straight in the clause because I want marker to be a specific value.
		       (or
		       [?b :block/scheduled ?d]  ; the block ?b has attribute scheduled with value ?d
		       [?b :block/deadline ?d]
		       )
		       [(< ?d ?day)]  ; the value ?d is smaller than the value ?day
		   ]
		   :inputs [:today]  ; use the Logseq dynamic variable :today as input for this query (gives today's date as yyyymmdd format)
		   :table-view? false
		  }
		  #+END_QUERY
	- # Open
		- #+BEGIN_QUERY
		  {:title [:h3 "✅ Planned"]
		   :query [:find (pull ?b [*])
		   :where
		     [?b :block/marker ?marker]
		     [(contains? #{"TODO" "LATER"} ?marker)]  ; TODO put in a value list with LATER.
		     (or
		     [?b :block/scheduled ?d]  ; ?b has attribute scheduled with value ?d, ?d is not further specified and so is any value. The same can be accomplish with _
		     [?b :block/deadline ?d]
		     )
		   ]
		   :result-transform (fn [result] (sort-by (fn [r] (get-in r [:block/scheduled])) result)) ; sort the result by the scheduled date
		   :table-view? false
		   :breadcrumb-show? false  ; don't show the parent blocks in the result !important, due to result-transform the grouping is lost, and so you will be left with a simple list of TODO items. having those parents blocks mixed in may make the list more confusing. (setting this to true won't show the page btw!)
		   :collapsed? false
		  }
		  #+END_QUERY
		- #+BEGIN_QUERY
		  {:title [:h3 "☑ Unplanned"]
		   :query [:find (pull ?b [*])
		   :in $ ?day
		   :where
		     [?p :block/journal-day ?d]  ; ?p has the attribute journal-day with value ?d (you don't need the :block/journal? attribute if you also use this one)
		     [(<= ?d ?day)]
		     [?b :block/page ?p]  ; ?b has the attribute :block/page with value ?p, ?p has been define with the identifier of a journal page above.
		     [?b :block/marker "TODO"]
		     (not [?b :block/scheduled _])  ; ?b doesn't have the attribute scheduled (_ is used to say that the value doesn't matter. If a value is specified it would read as ?b may have the attribute, but not with that value)
		     (not [?b :block/deadline _])
		   ]
		   :result-transform (fn [result] (sort-by (fn [r] (get-in r [:block/page :block/journal-day])) result))  ; Sort by the journal date
		   :inputs [:today]
		   :table-view? false
		   :breadcrumb-show? false
		   :collapsed? false
		  }
		  #+END_QUERY
		- #+BEGIN_QUERY
		  {:title [:h3 "🔥 Yesterday's open tasks"]
		   :query [:find (pull ?b [*])
		   :in $ ?day
		   :where
		     [?p :block/journal-day ?day]  ; Here we input the value of the input into the clause immediately as it is an = statement.
		     [?b :block/page ?p]
		     [?b :block/marker "TODO"]
		     (or
		       [?b :block/scheduled ?day]  ; Either the scheduled value is equal to ?day
		       (not [?b :block/scheduled])  ; or the scheduled attribute doesn't exist (_ is omitted here, it is instead implied)
		     )
		     (or
		       [?b :block/deadline ?day]  ; same as above, but for the deadline attribute.
		       (not [?b :block/deadline])
		      )
		   ]
		   :inputs [:yesterday]
		   :table-view? false
		  }
		  #+END_QUERY
		- #+BEGIN_QUERY
		  {:title "📅  NEXT 3 DAYS, NOT TODAY"
		      :query [:find (pull ?h [*])
		              :in $ ?next ?today
		              :where
		              [?h :block/marker ?m]
		              [(contains? #{"LATER" "TODO"} ?m)]
		              (or-join [?h ?d]
		                (and
		                  [?h :block/refs ?p]
		                  [?p :block/journal-day ?d]
		                )
		                [?h :block/scheduled ?d]
		                [?h :block/deadline ?d]
		              )
		              [(< ?d ?next)]
		              [(> ?d ?today)]
		      ]
		      :inputs [:3d-after :today]
		      :table-view? false
		      :breadcrumb-show? false
		      :collapsed? false
		  }
		  #+END_QUERY
		- collapsed:: true
		  #+BEGIN_QUERY
		  {:title "📅 WITHIN NEXT 3 DAYS"
		      :query [:find (pull ?h [*])
		              :in $ ?next
		              :where
		              [?h :block/marker ?m]
		              [(contains? #{"LATER" "TODO"} ?m)]
		              (or-join [?h ?d]
		                (and
		                  [?h :block/ref-pages ?p]
		                  [?p :block/journal? true]
		                  [?p :block/journal-day ?d])
		                [?h :block/scheduled ?d]
		                [?h :block/deadline ?d])
		              [(< ?d ?next)]]
		      :inputs [:3d-after] 
		      :table-view? false
		      :collapsed? true}
		  #+END_QUERY
	- # Scheduled
		- #+BEGIN_QUERY
		  {:title [:h3 "🎯 Planned"]
		   :query [:find (pull ?b [*])
		   :in $ ?day
		   :where
		     [?b :block/deadline ?d]
		     [(<= ?d ?day)]
		     [?b :block/marker "TODO"]
		     [?b :block/scheduled _]
		   ]
		   :result-transform (fn [result] (sort-by (juxt (fn [r] (get-in r [:block/scheduled])) (fn [r] (get-in r [:block/deadline])) ) result))  ; Sort first by scheduled and then by deadline.
		   :breadcrumb-show? false
		   :table-view? false
		   :inputs [20230212]
		  }
		  #+END_QUERY
	- # Unscheduled
		- #+BEGIN_QUERY
		  {:title [:h3 "🎯 Not yet planned"]
		   :query [:find (pull ?b [*])
		   :in $ ?day
		   :where
		     [?b :block/deadline ?d]
		     [(<= ?d ?day)]
		     [?b :block/marker "TODO"]
		     (not [?b :block/scheduled _])
		  ]
		    :result-transform (fn [result] (sort-by (fn [r] (get-in r [:block/deadline])) result))
		    :breadcrumb-show? false
		    :table-view? false
		    :inputs [20230212]
		  }
		  #+END_QUERY
- # Management
  id:: 65d4fd19-5f49-49e0-85d6-14539c24b1f8
	- ![task_management_idea.png](../assets/task_management_idea_1708122057204_0.png)
