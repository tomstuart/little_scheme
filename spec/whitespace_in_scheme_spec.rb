describe 'a little Scheme' do
  context 'despite what the book says, can cope with extra whitespace to make programs more reable' do
    include SyntaxMatchers

    specify { expect(' atom ').to be_an_atom }
    specify { expect(' 1492 ').to be_an_atom }

    describe '(atom  otheratom) ' do
      it { is_expected.to be_a_list }
      it { is_expected.to contain_the_s_expressions 'atom', 'otheratom' }
    end

    describe ' (atom) ' do
      it { is_expected.to be_a_list }
      it { is_expected.to contain_the_s_expressions 'atom' }
    end

    describe '
(
 a
 b
 c
)
             ' do
      it { is_expected.to be_a_list }
      it { is_expected.to contain_the_s_expressions 'a', 'b', 'c' }
    end
  end
end
