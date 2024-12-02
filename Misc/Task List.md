## Priority A
	- {{query (and (task TODO DOING) (priority A))}}
- ## Priority B
	- {{query (and (task TODO DOING) (priority B))}}
- ## Priority C
	- {{query (and (task TODO DOING) (priority C))}}
- ## Unprioritized
	- {{query (and (task TODO DOING) (not (priority A B C)))}}
-
-
- ## Tasks past due
  
  Tasks scheduled value is past due (based on today)
  
  #+BEGIN_QUERY
  {:title [:h3 "🔥 Past scheduled"]
  :query [:find (pull ?b [*])
   :in $ ?day  ; ?day is the name for the first value in inputs further down.
   :where
     [?b :block/marker "TODO"]  ; Using TODO straight in the clause because I want marker to be a specific value.
     [?b :block/scheduled ?d]  ; the block ?b has attribute scheduled with value ?d
     [(< ?d ?day)]  ; the value ?d is smaller than the value ?day
  ]
  :inputs [:today]  ; use the Logseq dynamic variable :today as input for this query (gives today's date as yyyymmdd format)
  :table-view? false
  }
  #+END_QUERY
- ## Open scheduled tasks
  
  #+BEGIN_QUERY
  {:title [:h3 "✅ Planned"]
  :query [:find (pull ?b [*])
  :where
   [?b :block/marker ?marker]
   [(contains? #{"TODO" "LATER"} ?marker)]  ; TODO put in a value list with LATER.
   [?b :block/scheduled ?d]  ; ?b has attribute scheduled with value ?d, ?d is not further specified and so is any value. The same can be accomplish with _
  ]
  :result-transform (fn [result] (sort-by (fn [r] (get-in r [:block/scheduled])) result)) ; sort the result by the scheduled date
  :table-view? false
  :breadcrumb-show? false  ; don't show the parent blocks in the result !important, due to result-transform the grouping is lost, and so you will be left with a simple list of TODO items. having those parents blocks mixed in may make the list more confusing. (setting this to true won't show the page btw!)
  :collapsed? false
  }
  #+END_QUERY
- ## Open unplanned tasks from journal pages
  
  #+BEGIN_QUERY
  {:title [:h3 "☑ Unplanned"]
  :query [:find (pull ?b [*])
  :in $ ?day
  :where
   [?p :block/journal-day ?d]  ; ?p has the attribute journal-day with value ?d (you don't need the :block/journal? attribute if you also use this one)
   [(< ?d ?day)]
   [?b :block/page ?p]  ; ?b has the attribute :block/page with value ?p, ?p has been define with the identifier of a journal page above.
   [?b :block/marker "TODO"]
   (not [?b :block/scheduled _])  ; ?b doesn't have the attribute scheduled (_ is used to say that the value doesn't matter. If a value is specified it would read as ?b may have the attribute, but not with that value)
  ]
  :result-transform (fn [result] (sort-by (fn [r] (get-in r [:block/page :block/journal-day])) result))  ; Sort by the journal date
  :inputs [:today]
  :table-view? false
  :breadcrumb-show? false
  :collapsed? false
  }
  #+END_QUERY
- ## Yesterday's open tasks
  
  Tasks open from yesterday's journal page, that don't have a deadline/scheduled date or their deadline/scheduled date was yesterday.
  
  #+BEGIN_QUERY
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
- ## Deadline to be scheduled
  
  Not yet scheduled with deadline on certain day (I use the coming Sunday as a date)
  
  #+BEGIN_QUERY
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
- ## Scheduled with deadline
  
  Planned, with deadline on certain date (again I use the next Sunday)
  
  #+BEGIN_QUERY
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
- ## Todo in sub block / Project-specific queries
- ## 
  
  #+BEGIN_QUERY
  {:title "🔨 Project TODO"
  :query [:find (pull ?b [*])
          :where
          [?p :block/name "logseq"]
          [?par :block/refs ?p]
          (or [?b :block/parent ?par]
                 [?b :block/refs ?p])
          [?b :block/marker ?marker]
          [(contains? #{"TODO"} ?marker)]
  ]
  }
  #+END_QUERY
- #+BEGIN_QUERY
  {:title "🔨 Project TODO"
  :query [:find (pull ?b [*])
          :where
          [?p :block/name "logseq"]
          [?par :block/refs ?p]
          (or [?b :block/parent ?par]
                 [?b :block/refs ?p])
          [?b :block/marker ?marker]
          [(contains? #{"TODO"} ?marker)]
  ]
  }
  #+END_QUERY
- ## Sorting options for simple deadline/scheduled query
  
  #+BEGIN_QUERY
  {:title ["📆 near TODOs (next 7 days, scheduled or deadline) (Sorting by scheduled date)"] 
     :query [:find (pull ?b [*])
          :in $ ?start ?next
          :where
          (or
            [?b :block/scheduled ?d]
            [?b :block/deadline ?d]
          )
          [(>= ?d ?start)]
          [(<= ?d ?next)]
  ]
  :result-transform (fn [result] (sort-by (fn [d] (get d :block/scheduled) ) result))
  :inputs [:today :7d-after]
  :collapsed? false}
  #+END_QUERY
  
  #+BEGIN_QUERY
  {:title ["📆 near TODOs (next 7 days, scheduled or deadline) (Sorting by deadline)"] 
     :query [:find (pull ?b [*])
          :in $ ?start ?next
          :where
          (or
            [?b :block/scheduled ?d]
            [?b :block/deadline ?d]
          )
          [(>= ?d ?start)]
          [(<= ?d ?next)]
  ]
  :result-transform (fn [result] (sort-by (fn [d] (get d :block/deadline) ) result))
  :inputs [:today :7d-after]
  :collapsed? false}
  #+END_QUERY
  
  #+BEGIN_QUERY
  {:title ["📆 near TODOs (next 7 days, scheduled or deadline) (Sort by scheduled then deadline)"] 
     :query [:find (pull ?b [*])
          :in $ ?start ?next
          :where
          (or
            [?b :block/scheduled ?d]
            [?b :block/deadline ?d]
          )
          [(>= ?d ?start)]
          [(<= ?d ?next)]
  ]
  :result-transform (fn [result] (sort-by (juxt (fn [d] (get d :block/scheduled) ) (fn [d] (get d :block/deadline) ) ) result))
  :inputs [:today :7d-after]
  :collapsed? false}
  #+END_QUERY
- ## Tasks that have specific page reference
  
  #+BEGIN_QUERY
  {:title [:h3 "Tasks with page reference" ]
  :query [:find (pull ?b [*])
    :where
      [?p :block/name "page"] ; name is always lowercase
      [?b :block/refs ?p] ; this block references ?p as oppose to being on ?p through :block/page.
      [?b :block/marker "TODO"]
  ]
  }
  #+END_QUERY
- ## Tasks without a specific page link
  
  #+BEGIN_QUERY
  {:title [:h3 "Tasks with reference" ]
  :query [:find (pull ?b [*])
   :where
     [?p :block/name "page"] ; name is always lowercase
     [?b :block/marker "TODO"]
     (not [?b :block/refs ?p]) ; we cannot use not until we have specified the variables used in it
  ]
  }
  #+END_QUERY
- #+BEGIN_QUERY
  {:title [:h3 "Tasks without page reference (new logseq version change?)" ]
   :query [:find (pull ?b [*])
     :where
       [?p :block/name "habit-tracker"] ; name is always lowercase
       [?b :block/marker "TODO"]
       (not [?b :block/scheduled])
       (not [?b :block/deadline])
       (not [?b :block/refs ?p]) ; we cannot use not until we have specified the variables used in it
   ]
     :table-view? false
     ; :breadcrumb-show? false
     :group-by-page? false
  }
  #+END_QUERY
-
- #+BEGIN_QUERY
  {:title "List of tasks without page reference"
   :query [:find (pull ?b [*])
     :where
       [?b :block/marker ?m]
       (not [(contains? #{"DONE" "CANCELED"} ?m)] )
       (not 
         [?b :block/parent ?par]
         [?par :block/marker]
       )
   ]
   :group-by-page? false
   :breadcrumb-show? false
  ; :group-by-page? false 
  }
  #+END_QUERY
-
- #+BEGIN_QUERY
  {:title "✅ Count of DOING and LATER Tasks"
   :query [:find ?marker (count ?b)
           :keys type number
           :where
           [?b :block/marker ?marker]
           [(contains? #{"DOING" "LATER"} ?marker)]
           :group-by ?marker]
   :view (fn [rows] [:table
     [:thead [:tr [:th "Type"] [:th "Count"] ] ]
     [:tbody (for [r rows] [:tr
               [:td (get-in r [:type])]
               [:td (get-in r [:number])]
             ])
     ]])
  }
  #+END_QUERY
-
- #+BEGIN_QUERY
  {:title "✅ Count of TODO Tasks"
   :query [:find ?marker (count ?b)
           :keys type number
           :where
           [?b :block/marker ?marker]
           [(contains? #{"TODO"} ?marker)]
           :group-by ?marker]
   :view (fn [rows] [:table
     [:thead [:tr [:th "Type"] [:th "Count"] ] ]
     [:tbody (for [r rows] [:tr
               [:td (get-in r [:type])]
               [:td (get-in r [:number])]
             ])
     ]])
  }
  #+END_QUERY
-
- ## Unscheduled non-project tasks
  
  Tasks that are not scheduled and not on a page with tags:: projecten (this property creates page links)
  
  #+BEGIN_QUERY
  {:title [:h3 "🔔 Ongeplande taken"]
  :query [:find (pull ?b [*])
   :where
     [?b :block/marker "TODO"]
     (not [?b :block/scheduled])
     [?b :block/page ?p]
     [?pr :block/name "projecten"]
     (not [?p :block/tags ?pr])
  ]
  :table-view? false
  }
  #+END_QUERY
- ## Tasks by current page & it's aliases
  
  This uses a more complex or statement. This is basically a logical or. it is needed here as variable ?a is only for use in the or. [?b ?p] means these two variables are bound with the rest of the query.
  
  More information: https://docs.datomic.com/on-prem/query/query.html#or-join-clause
  
  #+BEGIN_QUERY
  {:title ["Query by page & alias"]
  :query [:find (pull ?b [*])
   :in $ ?page
   :where
     [?b :block/marker "TODO"]
     [?p :block/name ?page]
     (or-join [?b ?p]
       [?b :block/refs ?p] 
       (and [?p :block/alias ?a] ; this attribute is available only when alias:: has been specified as a page property.
          [?b :block/refs ?a])
     )
  ]
  :result-transform :sort-by-priority
  :table-view? false
  :inputs [:current-page] ; alternatively use :query-page to use the page the query is on, rather than the page you are viewing
  }
  #+END_QUERY
-
- ## All tasks that have a deadline and aren't done or canceled.
  
  #+BEGIN_QUERY
  {:title [:h3 "Deadline"]
  :query [:find (pull ?b [*])
  :where
   [?b :block/deadline ?d]
   [?b :block/marker ?m]
   (not [(contains? #{"DONE" "CANCELED"} ?m)])
  ]
  }
  #+END_QUERY
- ## Tasks with their page name
  
  A little bit more of an advanced query, using a view to make a table of the page name and task.
  
  It will get rid of the checkbox unfortunately, but the task is clickable to navigate to it.
  
  #+BEGIN_QUERY
  {:title "Task on page"
  :query [:find (pull ?b [*])
   :where
     [?b :block/marker "TODO"]
     [?b :block/page ?p]
  ]
  :result-transform (fn [result] (sort-by (fn [d] (get d :block/page :block/original-name)) result))
  :view (fn [rows] [:table [:thead [:tr [:th "Page"] [:th "Task"] ] ]
   [:tbody (for [r rows] [:tr
     [:td [:a {:href 
       (str "#/page/" (clojure.string/replace (get-in r [:block/page :block/original-name]) "/" "%2F"))} 
         (get-in r [:block/page :block/original-name])] 
     ]
     [:td [:a {:href (str "#/page/" (get r :block/uuid))} (get r :block/content)]]
   ])
  ]])
  }
  #+END_QUERY
- ## Tasks that don't reference a page regardless of nesting
  collapsed:: true
  
  This will exclude any tasks that are referencing a page or that one of the parent blocks references a page. This query uses rules for recursive searching.
  
  To change this to reference instead of don't reference, just remove the (not and closing ) around (check-ref ?p ?b)
  
  #+BEGIN_QUERY
  {:title "🔨 TODO"
  :query [:find (pull ?b [*])
   :in $ % ; % is used to pull in the rules below.
   :where
     [?b :block/marker ?marker]
     [(contains? #{"TODO"} ?marker)]
     ;; Exclude pagename
     [?p :block/name "pagename"]
     (not (check-ref ?p ?b)) ; this calls the rules below.
  ]
  :rules [ ; whenever two rules have the same name an or is applied. I'm not exactly sure how to explain it!
   [(check-ref ?p ?b) ; definition of the rule, name and parameters.
     [?b :block/refs ?p] ; rule content to be executed
   ]
   [(check-ref ?p ?b)
     [?b :block/parent ?t]
     (check-ref ?p ?t) ; calling the rule again within this rule will make it recursive.
   ]
  ]
  :breadcrumb-show? false
  :collapsed? true
  }
  #+END_QUERY
-
- ## Tasks past either scheduled or deadline date
  
  #+BEGIN_QUERY
  {:title [:h3 "🔥 Tasks past due"]
  :query [:find (pull ?b [*])
  :in $ ?day
  :where
   [?b :block/marker ?m]
   (not [(contains? #{"DONE" "CANCELED"} ?m)])
   (or
     [?b :block/scheduled ?d]  ; Either the scheduled value
     [?b :block/deadline ?d] ; or the deadline value
    )
    [(< ?d ?day)] ; the value is in the past
  ]
  :inputs [:today]
  :table-view? false
  }
  #+END_QUERY
-
- ## query that excutes its task only if the time is past 4pm, and before 6am
- The query will always run. However upon refresh it may or may not show content.
- I use it to show start of day and end of day reflection. So most of 
  the time this query shows “no matched results”. But at specific times it
  does.
- #+BEGIN_QUERY
  {:title [:h4 "🧘🏽‍♀️ Reflectie"]
  :query [:find (pull ?b [*])
  :in $ ?now ?o ?a
  :where
   [?p :block/name "reflectie"]
   [?b :block/page ?p]
   [?b :block/content ?c] ;blocks on page reflectie with certain content
   (or   ; different rules to validate against
     (and
       [(<= ?now ?o)] ; now is before 13:00
       [(clojure.string/includes? ?c "Begin van de dag")] ;block includes this content
     )
     (and
       [(<= ?a ?now)] ; now is after 17:30
       [(clojure.string/includes? ?c "Eind van de dag")] ;block includes this content
     )
   ) ;If none of this is true, show nothing
  ]
  :result-transform (fn [r] (map (fn [m] (assoc m :block/collapsed? true)) r)) ;show the block collapsed
  :inputs [:right-now-ms :today-1300 :today-1730] ;the time now, at 13:00 and 17:30
  }
  #+END_QUERY
-
- ## get all tasks from _specific_ page after 16:00
- collapsed:: true
  #+BEGIN_QUERY
  {:title [:h4 "🧘🏽‍♀️ Reflectie pull tasks"]
   :query [:find (pull ?h [*])
    :in $ ?now ?a
    :where
     [?h :block/marker ?marker]
     [(contains? #{"NOW" "LATER"} ?marker)]
     [?p :block/name "maison"]
     [?h :block/page ?p]
     [(>= ?a ?now)] ; now is before 18:00
   ]
   :result-transform (fn [r] (map (fn [m] (assoc m :block/collapsed? true)) r)) ;show the block collapsed
   :inputs [:right-now-ms :today-1800] ;the time now and at 18:00
   :collapsed? true
  }
  #+END_QUERY
-
- ## Recursively search for tasks that are tagged or have their parent tagged with current page.
  
  Combining “Tasks by current page & it's aliases” with the recursive search from “Tasks that don't reference a page regardless of nesting”
  
  #+BEGIN_QUERY
  {:title ["Query by page & alias"]
  :query [:find (pull ?b [*])
   :in $ ?page %
   :where
     [?b :block/marker "TODO"]
     [?p :block/name ?page]
     (or-join [?b ?p]
       (check-ref ?p ?b) 
       (and 
          [?p :block/alias ?a]
          (check-ref ?a ?b)
       )
     )
  ]
  :rules [
   [(check-ref ?p ?b)
     [?b :block/refs ?p]
   ]
   [(check-ref ?p ?b)
     [?b :block/parent ?t]
     (check-ref ?p ?t)
   ]
  ]
  :table-view? false
  :inputs [:current-page]
  }
  #+END_QUERY
-
- ## Query all tasks related to one common tag
  
  #+BEGIN_QUERY
  {:title "Work tasks"
  :query [:find (pull ?b [*])
   :where
     [?t :block/name "work"] ; always lowercase
     [?p :block/tags ?t]
     [?b :block/refs ?p]
     [?b :block/marker ?m]
     [(contains? #{"TODO" "DOING"} ?m)]
  ]
  }
  #+END_QUERY
-
- ## query building task counter for projects
- query equivalent to `{{query (page-property type [[Thing]])}}`, though adding a column with respective task counts…
- Not being able to make it work because when filtering blocks through markers, the ones that have NO tasks don’t show up
- #+BEGIN_QUERY
  {:title [:h3 "⚡️ Lopend"]
   :query [:find ?project (count ?b) (sum ?count) ;count ?b is required to show the correct sum of ?count
     :keys project block taken ;define keys to use in the view below
     :where
       [?t :block/name "taskcount"] ;page named taskcount
       [?p :block/tags ?t] ;get all pages tagged with taskcount
       [?p :block/journal? false] ;that aren't journals
       [?p :block/original-name ?project] ;put the original page name in variable ?project
       [?b :block/page ?p] ;get blocks on the found pages
       ;Anything above this line can be edited to fit what you need to find in terms of a project name and related tasks!
       (or
         (and
           [?b :block/marker "TODO"] ;block is a task
           [(* 1 1) ?count] ;set count to 1
         )
         (and
           (not [?b :block/marker "TODO"]) ;block is not a task
           [(* 0 1) ?count] ;set count to zero
         )
       )
   ]
   ;Use of :view to display our result in a table
   :view (fn [rows] [:table 
     [:thead [:tr [:th "Project"] [:th "Tasks"] ] ]
     [:tbody (for [r rows] [:tr 
       [:td [:a {:href (str "#/page/" (clojure.string/replace (get-in r [:project]) "/" "%2F"))} (get-in r [:project])] ]
       [:td (get-in r [:taken]) ]
     ])]
   ])
  }
  #+END_QUERY
-
- ## Advanced Query that pulls all reference AND recursive name spaces
  
  > What does this query do?
  
  This query pulls all the undone tasks that reference the current page somewhere in their path OR reside on any-level namespace below it. It shows them all.
  
  > How is it meant to be used?
  
  Imagine you have the following hierachy: Work/Company A/Project X. You could paste this query on all three of the pages (Work, Work/Company A, Work/Company A/Project X) and it would show you all tasks related to that page including children pages from that point. It does not matter whether you tag a page inline, you indent under it or you put it on the page itself, it collects all those things.
  
  So besides putting it on the pages itself you could do
  
    LATER From everywhere in Logseq, you can tag and it shows up in [[Work]]
    [[Work/Company A]]
        LATER Task also show up both on pages 'Company A' and 'Work' when tagged like this
    [[Work/Company A/Project 1]]
        We have a meeting here
            Another bullet point
                LATER This task is also found under 'Work', 'Company A' & 'Project 1' pages. As the depth does not matter
	- limitation:
	  * Logseq doesn't really handles aliases well. You'll need to reference the entire namespace in order for the tasks to show up. So if you were to only tag [[Company A]], then it doesn't show up (also not at page 'Company A', as it is really page 'Work/Company A'. Logseq doesn't internally link aliases like that. I really think this is a bug rather than a feature. Hope it changes sometime soon. Until then, we're stuck with referencing the entire namespace always.
	  
	  Edit: I just saw in the 'Queries for Task Management' thread that there is something like an (or-join) which could potentially solve this problem. I'll leave that note here for now, I'm not gonna look into that myself for now.
	  
	  Hope it helps anyone, cost me way to much time as ChatGPT doesn't understand Datalog nearly as well as it does Python :')
- #+BEGIN_QUERY
  ; see https://discuss.logseq.com/t/advanced-query-that-pulls-all-reference-and-recursive-name-spaces/21275/8
  {:title [:h3 "Recursive Namespace + Alias Tasks - Siferiax" ]
    :query [:find (pull ?b [*])
      :in $ ?inputpage %
      :where
      [?b :block/marker ?m]
      [(contains? #{"NOW" "LATER" "TODO" "DOING"} ?m)]
      (or-join [?b ?inputpage]
        (and ; Is de page the task is on part of the namespace of the input page?
          [?b :block/page ?p]
          [?ns :block/name ?inputpage]
          (check-ns ?ns ?p)
        )
        (and ; Does the task refer to the input page in its lineage?
          [?p :block/name ?inputpage]
          [?b :block/path-refs ?p]
        )
        (and ; Does the task refer to an alias in it's lineage, either of the input page or a page in its namespace?
          (or-join [?p ?inputpage]
            (and
              [?ns :block/name ?inputpage]
              (check-ns ?ns ?p)
            )
            [?p :block/name ?inputpage]
          )
          [?p :block/alias ?a]
          [?b :block/path-refs ?a]
        )
      )
    ]
    :result-transform (fn [result]
      (let [sorted-result (sort-by (fn [h] (get h :block/marker)) > result)]
      (map (fn [m] (assoc m :block/collapsed? true)) sorted-result)))
    :group-by-page? false
    :breadcrumb-show? false
    :inputs [:current-page]
    :collapsed? false
    :rules [
      [(check-ns ?ns ?p)
        [?p :block/namespace ?ns]
      ]
      [(check-ns ?ns ?p)
        [?p :block/namespace ?t]
        (check-ns ?ns ?t)
      ]
    ]
  }
  #+END_QUERY
- #+BEGIN_QUERY
  {:title [:h3 "Complex Tasks list - CappieXL"]
  :query [:find (pull ?b [*])
       :in $ ?currentpage %
       :where
       ; Unified condition: Either it's from namespace or it references the page
       [?b :block/marker ?marker]
       [(contains? #{"NOW" "LATER" "TODO" "DOING"} ?marker)]
       (or
         (and
           [?b :block/page ?p]
           [?ns :block/name ?currentpage]
           (check-ns ?ns ?p)
         )
         (and
           [?p :block/name ?currentpage]
           [?ns :block/name ?currentpage] 
           [?b :block/path-refs ?p]
         )
       )
      ]
  :result-transform (fn [result]
                    (let [sorted-result (sort-by (fn [h] (get h :block/marker)) > result)]
                      (map (fn [m] (assoc m :block/collapsed? true)) sorted-result)))
  :group-by-page? false
  :breadcrumb-show? false
  :inputs [:current-page]
  :collapsed? false
  :rules [
  [(check-ns ?ns ?page)
   [?page :block/namespace ?ns]
  ]
  [(check-ns ?ns ?page)
   [?page :block/namespace ?t]
   (check-ns ?ns ?t)
  ]
  ]
  }
  #+END_QUERY
-
- ## all todos grouped by tag
- The two *contains* lines can be used to expand/change the query
  
  #+BEGIN_QUERY
  {:title "Find: tagged tasks"
  :query [:find (pull ?b [* {:block/_parent ...}])
  :where
    [?b :block/marker ?marker]
    [(contains? #{"LATER" "NOW"} ?marker)]
    [?b :block/ref-pages ?p]
    [?p :block/name ?tag]
    [(contains? #{"kdrama" "cdrama"} ?tag)]]
  }
  #+END_QUERY
- ## all todos with today's date
  {{query (and (task TODO) <%today%>)}}
-