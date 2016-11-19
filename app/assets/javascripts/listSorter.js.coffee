class @ListSorter
  getNextLetter: (letter) ->
    switch letter
      when 'top'
        return 'a'
      when 'z'
        return 'z'
      else
        return String.fromCharCode(letter.charCodeAt(letter.length - 1) + 1)
    return

  getLetterSequence: (start, end) ->
    #returns eg ^a|^b
    letterSet = []
    letter = start
    loop
      letterSet.push '^' + letter
      if letter == end
        break
      letter = @getNextLetter(letter)
    letterSet.join '|'

  handleTop: (endLetter) ->
    topRegex = /^\W|^\d|^a|/i
    if endLetter != 'top'
      sequence = @getLetterSequence('a', endLetter)
      return RegExp(topRegex.source + sequence, 'i')
    topRegex

  handleEnd: (startLetter) ->
    endRegex = /^x|^y|^z/i
    if !endRegex.test(startLetter)
      sequence = @getLetterSequence(startLetter, 'z')
      return RegExp(sequence + endPostfix.source, 'i')
    endRegex

  getSongFilter: (startLetter, endLetter) ->
    if startLetter == 'top'
      return @handleTop(endLetter)
    if startLetter == 'xyz'
      return @handleEnd(startLetter)
    sequence = @getLetterSequence(startLetter, endLetter)
    RegExp sequence, 'i'

  filterSongs: (songs, filterBy, startsWith, endsWith) ->
    songFilter = @getSongFilter(startsWith, endsWith)
    songs.filter (song) ->
      switch filterBy
        when 'song'
          return songFilter.test(song.name)
        when 'artist'
          return songFilter.test(song.artist_name)
