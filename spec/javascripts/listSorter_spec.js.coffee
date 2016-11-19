#= require listSorter

describe 'ListSorter', ->
  describe 'getNextLetter', ->
    sorter = new ListSorter()
    it 'should return the next letter in the alphabet', ->
      expect(sorter.getNextLetter('b')).to.equal 'c'

    it 'should a if give "top"', ->
      expect(sorter.getNextLetter("top")).to.equal 'a'

    it 'should return z given z', ->
      expect(sorter.getNextLetter('z')).to.equal 'z'
