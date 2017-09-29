function Algorithms.DepthFirstSearch (startingNode, edgeEnumeratorFactory, preOrderNodeSink, postOrderNodeSink)
	local visitedNodes = {}
	local function DepthFirstSearch (startingNode, edgeEnumeratorFactory, preOrderNodeSink, postOrderNodeSink, visitedNodes)
		if preOrderNodeSink then preOrderNodeSink (startingNode) end
		visitedNodes [startingNode] = true
		
		for node in edgeEnumeratorFactory (startingNode) do
			if not visitedNodes [node] then
				DepthFirstSearch (node, edgeEnumeratorFactory, preOrderNodeSink, postOrderNodeSink, visitedNodes)
			end
		end
		if postOrderNodeSink then postOrderNodeSink (startingNode) end
	end
	
	DepthFirstSearch (startingNode, edgeEnumeratorFactory, preOrderNodeSink, postOrderNodeSink, visitedNodes)
end

function Algorithms.DepthFirstSearchPreOrder (startingNode, edgeEnumeratorFactory, nodeSink)
	Algorithms.DepthFirstSearch (startingNode, edgeEnumeratorFactory, nodeSink, nil)
end

function Algorithms.DepthFirstSearchPostOrder (startingNode, edgeEnumeratorFactory, nodeSink)
	Algorithms.DepthFirstSearch (startingNode, edgeEnumeratorFactory, nil, nodeSink)
end
