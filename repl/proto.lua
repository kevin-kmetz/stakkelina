Repl = {}

function Repl.start()

    print("Stakkelina early prototype - REPL\n")

    local continueLoop = true

    while continueLoop do
        
        io.write('sl >>> ')
        local input = io.read()

        local tokens = tokenize(input)

        if input == 'exit' then break end

    end

end

function tokenize(input)



end

Parser = {}

function Parser.stripLeadingWhitespace(text)
end

function Parser.stripTrailingWhitespace(text)
end