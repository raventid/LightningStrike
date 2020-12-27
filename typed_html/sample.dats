implement main0 () =
    html<<<
        <div role="main">
            <h1>"Hello Kitty"</h1>
            <p>
                "This is a sample, jump to search: " <em><a href="https://google.com/">"google"</a></em>
            </p>
            <p>
                <button onclick={ |_event| alert("Hi, I'm checked!") }>
                    "Yep, I was checked somehow"
                </button>
            </p>
        </div>
    : Html>>>
