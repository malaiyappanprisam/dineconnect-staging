class AddUniqueIndexOnVotes < ActiveRecord::Migration
  def change
    add_index :votes, [:votable_id, :votable_type, :voter_id, :voter_type, :vote_scope], unique: true, name: "index_votes_on_votable_id_type_voter_id_type_scope"
  end
end
