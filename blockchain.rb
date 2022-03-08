require 'date'
require 'digest'

class Block
    attr_reader :index, :timestamp, :data, :previous_hash, :hash 
    attr_writer :index, :timestamp, :data, :previous_hash, :hash 
    def initialize
      index = 0
      timestamp = DateTime.now().strftime("%a %I:%M%p")
      data = ""
      previous_hash = ""
      hash = ""
    end
end

class Blockchain
    attr_reader :block_array
    attr_writer :block_array
    def initialize
        @block_array = []
    end

    def add_block(block)
        if @block_array.length() == 0
            block.index = 1
            block.previous_hash = ""
            block.hash = calculate_hash(block)
            block_array.append(block)
        else
            previous_block = block_array[@block_array.length() - 1]
            block.index = previous_block.index + 1
            block.previous_hash = previous_block.hash
            block.hash = calculate_hash(block)
            @block_array.append(block)
        end    
    end

    def calculate_hash(block)
        block_data = (block.index.to_s + block.timestamp.to_s + block.data + block.previous_hash)
        Digest::SHA256.hexdigest(block_data)
    end

    def print_blocks
        for block in block_array
            puts "Index: #{block.index}" 
            puts"Timestamp:#{block.timestamp}"
            puts "Data:#{block.data}" 
            puts "Previous hash: #{block.previous_hash}" 
            puts "Hash: #{block.hash}" 
            puts ""
        end
    end

    def verify
        blockchain_ok = TRUE
        for i in 0...block_array.length()
            if block_array[i].index == 1
                block_array[i].hash = calculate_hash(block_array[i])
                next
            else
                block_array[i].hash = calculate_hash(block_array[i])
                if block_array[i].previous_hash == block_array[i - 1].hash
                    next
                else
                    blockchain_ok = FALSE
                    break
                end
            end
        end
        return blockchain_ok
    end
end

block1 = Block.new
block1.data = "some transaction"

block2 = Block.new
block2.data = "cash transaction"

block3 = Block.new
block3.data = "nazbits"

blockchain = Blockchain.new
blockchain.add_block(block1)
blockchain.add_block(block2)
blockchain.add_block(block3)

blockchain.print_blocks()


blockchain.block_array[0].data = ""
puts blockchain.verify()