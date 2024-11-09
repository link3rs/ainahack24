from flask import Flask, request, jsonify, render_template
from markupsafe import escape
import os

from langchain import hub
#from langchain_chroma import Chroma
#from langchain.vectorstores import Chroma
from langchain_community.vectorstores import Chroma

from langchain_core.runnables import RunnablePassthrough
from langchain_core.output_parsers import StrOutputParser

from langchain_openai import OpenAIEmbeddings, ChatOpenAI
#from langchain.embeddings.openai import OpenAIEmbeddings
#from langchain.llms.openai import ChatOpenAI

from langchain_text_splitters import RecursiveCharacterTextSplitter
from langchain_community.document_loaders import ScrapflyLoader

from langchain.chains import RetrievalQA

app = Flask(__name__)

@app.route("/")
def hello_world():
    return "<p>Hello, World!</p>"

@app.route("/hello/<name>")
def hello(name):
    return f"Hello, {escape(name)}!"

@app.route('/projects/')
def projects():
    return 'The project page'

@app.route('/about')
def about():
    return 'The about page'


@app.route('/hi/<name>')
def hi(name=None):
    return render_template('hello.html', person=name)

# @app.post('/login')
#def login_post():
#    return do_the_login()


# Set your OpenAI and Scrapfly API keys
os.environ["OPENAI_API_KEY"] = "sk-Zz6------------------------APeciwH"
SCRAPFLY_API_KEY = "scp-live---------------------77ff6"

# Configure ScrapflyLoader
scrapfly_scrape_config = {
    "asp": True,
    "render_js": True,
    "proxy_pool": "public_residential_pool",
    "country": "us",
    "auto_scroll": True,
    "js": "",
}

scrapfly_loader = ScrapflyLoader(
    urls=["https://contractaciopublica.cat/ca/cerca-avancada?page=0&inclourePublicacionsPlacsp=false&sortField=dataUltimaPublicacio&sortOrder=desc"],
    api_key=SCRAPFLY_API_KEY,
    continue_on_failure=True,
    scrape_config=scrapfly_scrape_config,
    scrape_format="markdown",
)

# Load documents using ScrapflyLoader
documents = scrapfly_loader.load()

# Split documents into chunks
text_splitter = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=200)
splits = text_splitter.split_documents(documents)

# Create a vector store using OpenAI embeddings
vectorstore = Chroma.from_documents(documents=splits, embedding=OpenAIEmbeddings())

# Create a retriever from the vector store
retriever = vectorstore.as_retriever()

# Initialize the ChatOpenAI model
model = ChatOpenAI()

# Create a RetrievalQA chain
qa_chain = RetrievalQA.from_chain_type(
    llm=model,
    chain_type="stuff",
    retriever=retriever,
    return_source_documents=False,
)

# Define the /listen endpoint
@app.route('/listen', methods=['POST'])
def listen():
    data = request.get_json()

    # Extract the model and messages from the request
    model_name = data.get('model', '')
    messages = data.get('messages', [])

    # Find the last user message
    user_message = ''
    for message in reversed(messages):
        if message.get('role') == 'user':
            user_message = message.get('content', '')
            break

    if not user_message:
        return jsonify({'error': 'No user message found'}), 400

    # Use the QA chain to get the assistant's response
    response = qa_chain.run(user_message)

    # Build the assistant's message
    assistant_message = {
        'role': 'assistant',
        'content': response
    }

    # Append the assistant's message to the conversation
    messages.append(assistant_message)

    # Build the response JSON
    response_json = {
        'model': model_name,
        'messages': messages
    }

    return jsonify(response_json)

